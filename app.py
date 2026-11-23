import os, re
from datetime import date, datetime
import pandas as pd
import streamlit as st
from sqlalchemy import create_engine, text, inspect, URL
from sqlalchemy.exc import SQLAlchemyError
import plotly.express as px

st.set_page_config(page_title='Conservación Marina | PMV', page_icon='🌊', layout='wide')

USERS = {'Benjamin': ('1234', 'Administrador'), 'Operador': ('operador123', 'Operador')}

@st.cache_resource
def get_engine(host, port, username, password, db):
    url = URL.create('mysql+pymysql', username=username, password=password, host=host, port=int(port), database=db)
    return create_engine(url, pool_pre_ping=True, pool_recycle=1800)

def login():
    st.title('🌊 Sistema Integral de Gestión de Centros de Conservación Marina')
    st.caption('Plataforma de gestión y seguimiento de conservación marina')
    with st.form('login_form'):
        user = st.text_input('Usuario')
        pwd = st.text_input('Contraseña', type='password')
        ok = st.form_submit_button('Ingresar', type='primary', use_container_width=True)
    if ok:
        if user in USERS and USERS[user][0] == pwd:
            st.session_state.auth_user = user
            st.session_state.auth_role = USERS[user][1]
            st.rerun()
        else: st.error('Usuario o contraseña incorrectos.')
    st.info('Demo: Benjamin / 1234 (Administrador) · Operador / operador123 (Operador)')

def quote_ident(name):
    return '`' + str(name).replace('`', '``') + '`'

def tables(engine):
    return inspect(engine).get_table_names()

def get_columns(engine, table):
    return inspect(engine).get_columns(table)

def get_pk(engine, table):
    return inspect(engine).get_pk_constraint(table).get('constrained_columns') or []

def table_df(engine, table, limit=500):
    return pd.read_sql(text(f'SELECT * FROM {quote_ident(table)} LIMIT {int(limit)}'), engine)

def count_rows(engine, table):
    try:
        with engine.connect() as c: return int(c.execute(text(f'SELECT COUNT(*) FROM {quote_ident(table)}')).scalar() or 0)
    except Exception: return 0

def choose_table(all_tables, candidates):
    low = {t.lower(): t for t in all_tables}
    for cand in candidates:
        if cand.lower() in low: return low[cand.lower()]
    for t in all_tables:
        if any(c in t.lower() for c in candidates): return t
    return None

def safe_col(cols, candidates):
    names = {c['name'].lower(): c['name'] for c in cols}
    for candidate in candidates:
        if candidate.lower() in names: return names[candidate.lower()]
    for c in cols:
        if any(x in c['name'].lower() for x in candidates): return c['name']
    return None

def is_text_type(c):
    t = str(c.get('type','')).lower()
    return any(x in t for x in ['char','text','enum','varchar'])

def is_numeric(c):
    t = str(c.get('type','')).lower()
    return any(x in t for x in ['int','decimal','float','double','numeric'])

def input_for_column(c, key):
    name, typ = c['name'], str(c.get('type','')).lower()
    label = name.replace('_',' ').capitalize()
    if c.get('default') is not None or c.get('autoincrement') or c.get('identity'):
        st.caption(f'{label} (opcional; se puede dejar vacío)')
    if 'date' in typ and 'time' not in typ:
        return st.date_input(label, value=None, key=key)
    if 'time' in typ:
        return st.text_input(label + ' (HH:MM:SS)', key=key)
    if is_numeric(c):
        return st.number_input(label, value=0.0, key=key)
    if is_text_type(c):
        return st.text_input(label, key=key)
    return st.text_input(label, key=key)

def normalize_value(value, column):
    if value is None: return None
    if isinstance(value, date): return value.isoformat()
    if isinstance(value, str) and value.strip() == '': return None
    return value

def crud_page(engine, table, can_edit, title):
    st.subheader(title)
    cols = get_columns(engine, table); pks = get_pk(engine, table)
    st.caption(f'Tabla MySQL: {table} · registros: {count_rows(engine, table)}')
    df = table_df(engine, table)
    st.dataframe(df, use_container_width=True, hide_index=True)
    if not can_edit:
        st.info('Tu rol es de operador: puedes consultar datos, pero no modificar tablas maestras.')
        return
    tabs = st.tabs(['➕ Crear registro','✏️ Editar registro','🗑️ Eliminar registro'])
    with tabs[0]:
        with st.form(f'create_{table}'):
            vals = {}
            for c in cols: vals[c['name']] = input_for_column(c, f'new_{table}_{c["name"]}')
            submit = st.form_submit_button('Guardar registro', type='primary')
        if submit:
            payload = {k: normalize_value(v, next(x for x in cols if x['name']==k)) for k,v in vals.items()}
            payload = {k:v for k,v in payload.items() if v is not None}
            if not payload: st.warning('Ingresa al menos un dato.')
            else:
                try:
                    names = list(payload); sql = f"INSERT INTO {quote_ident(table)} ({', '.join(quote_ident(n) for n in names)}) VALUES ({', '.join(':'+n for n in names)})"
                    with engine.begin() as conn: conn.execute(text(sql), payload)
                    st.success('Registro creado correctamente.'); st.rerun()
                except SQLAlchemyError as e: st.error(f'No se pudo guardar: {e}')
    with tabs[1]:
        if df.empty: st.info('No hay registros para editar.')
        elif not pks: st.warning('Esta tabla no tiene una clave primaria detectada; no se habilita edición segura.')
        else:
            def rowlabel(row): return ' | '.join(f'{p}: {row[p]}' for p in pks)
            chosen = st.selectbox('Selecciona registro', df.to_dict('records'), format_func=rowlabel, key=f'edit_sel_{table}')
            with st.form(f'edit_form_{table}'):
                vals={}
                for c in cols:
                    vals[c['name']] = st.text_input(c['name'], value='' if pd.isna(chosen.get(c['name'])) else str(chosen.get(c['name'])), key=f'edit_{table}_{c["name"]}')
                save=st.form_submit_button('Actualizar registro')
            if save:
                try:
                    payload={k:v for k,v in vals.items() if k not in pks}
                    where=' AND '.join(f'{quote_ident(p)} = :pk_{i}' for i,p in enumerate(pks))
                    args={f'pk_{i}':chosen[p] for i,p in enumerate(pks)}
                    with engine.begin() as conn: conn.execute(text(f"UPDATE {quote_ident(table)} SET {', '.join(quote_ident(k)+' = :'+k for k in payload)} WHERE {where}"), {**payload,**args})
                    st.success('Registro actualizado.'); st.rerun()
                except SQLAlchemyError as e: st.error(f'No se pudo actualizar: {e}')
    with tabs[2]:
        if df.empty: st.info('No hay registros para eliminar.')
        elif not pks: st.warning('No se detectó clave primaria; no se habilita eliminación segura.')
        else:
            chosen=st.selectbox('Selecciona registro a eliminar',df.to_dict('records'),format_func=lambda row: rowlabel(row),key=f'del_sel_{table}')
            confirm=st.checkbox('Confirmo que deseo eliminar este registro',key=f'del_confirm_{table}')
            if st.button('Eliminar definitivamente',disabled=not confirm,key=f'del_btn_{table}'):
                try:
                    where=' AND '.join(f'{quote_ident(p)} = :pk_{i}' for i,p in enumerate(pks)); args={f'pk_{i}':chosen[p] for i,p in enumerate(pks)}
                    with engine.begin() as conn: conn.execute(text(f'DELETE FROM {quote_ident(table)} WHERE {where}'),args)
                    st.success('Registro eliminado.'); st.rerun()
                except SQLAlchemyError as e: st.error(f'No se pudo eliminar (puede tener relaciones): {e}')

def dashboard(engine, all_tables):
    st.title('📊 Dashboard de gestión')
    center=choose_table(all_tables,['centro']); species=choose_table(all_tables,['especie_marina','especie']); visitors=choose_table(all_tables,['visitante']); activities=choose_table(all_tables,['actividad'])
    cards=[('Centros',center),('Especies',species),('Visitantes',visitors),('Actividades',activities)]
    metrics=st.columns(4)
    for i,(label,t) in enumerate(cards): metrics[i].metric(label, count_rows(engine,t) if t else 'N/D')
    st.markdown('### Indicadores generales')
    for t,label in [(center,'Centros de conservación'),(species,'Especies marinas'),(visitors,'Visitantes'),(activities,'Actividades')]:
        if t:
            d=table_df(engine,t)
            with st.expander(f'📋 Datos: {label}',expanded=False): st.dataframe(d,use_container_width=True,hide_index=True)
    # Charts using actual count data
    available=[(label,t) for label,t in cards if t]
    if available:
        chartdf=pd.DataFrame({'Categoría':[a for a,t in available], 'Cantidad':[count_rows(engine,t) for a,t in available]})
        st.plotly_chart(px.bar(chartdf,x='Categoría',y='Cantidad',title='Cantidad de registros por categoría',text_auto=True),use_container_width=True)
    st.markdown('### Consultas de negocio')
    st.markdown('**1. ¿Cuántos centros, especies, visitantes y actividades están registrados?**')
    st.markdown('**2. ¿Qué centros y especies se encuentran registrados actualmente?**')
    st.markdown('**3. ¿Cuántos visitantes y actividades existen en el sistema?**')
    st.markdown('**4. ¿Cómo se distribuyen los registros entre las categorías principales de gestión?**')
    if center:
        st.markdown('#### Listado de centros')
        st.dataframe(table_df(engine,center),use_container_width=True,hide_index=True)
    if species:
        st.markdown('#### Listado de especies')
        st.dataframe(table_df(engine,species),use_container_width=True,hide_index=True)

def registration(engine, all_tables):
    st.title('📝 Registro de visitantes / participación')
    vtable=choose_table(all_tables,['visitante']); atable=choose_table(all_tables,['actividad']); linktable=choose_table(all_tables,['asiste','participa','inscripcion','inscripción','registro_actividad'])
    if not vtable or not atable:
        st.warning('No se detectaron las tablas visitante y actividad en la base de datos. Revisa el esquema.'); return
    vcols=get_columns(engine,vtable); acols=get_columns(engine,atable)
    st.write('Formulario transaccional para registrar visitantes y su participación en actividades.')
    activity = None
    with st.form('transaction_form'):
        visitor={}
        for c in vcols:
            visitor[c['name']]=input_for_column(c,'tx_visitor_'+c['name'])
        st.markdown('#### Actividad')
        adf=table_df(engine,atable)
        if adf.empty: st.warning('No existen actividades disponibles para seleccionar.')
        else:
            activity=st.selectbox('Selecciona actividad',adf.to_dict('records'),format_func=lambda r: ' | '.join(str(r[c]) for c in adf.columns[:3]))
        submitted=st.form_submit_button('Registrar participación',type='primary')
    if submitted:
        vpayload={k:normalize_value(v,next(c for c in vcols if c['name']==k)) for k,v in visitor.items()}
        vpayload={k:v for k,v in vpayload.items() if v is not None}
        if not vpayload: st.error('Completa los datos del visitante.')
        else:
            try:
                with engine.begin() as conn:
                    colnames=list(vpayload)
                    insert_sql=f"INSERT INTO {quote_ident(vtable)} ({', '.join(quote_ident(k) for k in colnames)}) VALUES ({', '.join(':'+k for k in colnames)})"
                    result=conn.execute(text(insert_sql),vpayload)
                    new_id=result.lastrowid
                    if linktable and activity is not None:
                        lcols=get_columns(engine,linktable)
                        vcol=safe_col(lcols,['cod_visitante','id_visitante','visitante_id'])
                        acol=safe_col(lcols,['cod_actividad','id_actividad','actividad_id'])
                        if vcol and acol:
                            pkv=vpayload.get(vcol,new_id)
                            activity_pk=get_pk(engine,atable)
                            aid=activity.get(activity_pk[0]) if activity_pk else activity.get(acols[0]['name'])
                            conn.execute(text(f'INSERT INTO {quote_ident(linktable)} ({quote_ident(vcol)},{quote_ident(acol)}) VALUES (:v,:a)'),{'v':pkv,'a':aid})
                st.success('Registro guardado.'); st.rerun()
            except SQLAlchemyError as e: st.error(f'La transacción no pudo completarse: {e}')
    st.caption('Si la base de datos no cuenta con tabla de relación entre visitante y actividad, el formulario registra al visitante; la relación se habilita cuando se detecta una tabla compatible.')

if 'auth_user' not in st.session_state: login(); st.stop()

st.sidebar.title('🌊 Conservación Marina')
st.sidebar.write(f'Usuario: **{st.session_state.auth_user}**')
st.sidebar.write(f'Rol: **{st.session_state.auth_role}**')
if st.sidebar.button('Cerrar sesión'): st.session_state.clear(); st.rerun()
st.sidebar.divider(); st.sidebar.subheader('Conexión MySQL')
host=st.sidebar.text_input('Host',os.getenv('DB_HOST','localhost'))
port=st.sidebar.number_input('Puerto',value=int(os.getenv('DB_PORT','3306')),min_value=1,max_value=65535)
user=st.sidebar.text_input('Usuario MySQL',os.getenv('DB_USER','root'))
password=st.sidebar.text_input('Contraseña MySQL',os.getenv('DB_PASSWORD',''),type='password')
db=st.sidebar.text_input('Base de datos',os.getenv('DB_NAME','conservacion_marina'))
if st.sidebar.button('Conectar a MySQL',type='primary'):
    try:
        eng=get_engine(host,int(port),user,password,db); eng.connect().close()
        st.session_state.db_cfg={'host':host,'port':int(port),'user':user,'password':password,'db':db}; st.sidebar.success('Conexión OK')
    except Exception as e: st.sidebar.error(f'Error de conexión: {e}')
if 'db_cfg' not in st.session_state:
    st.warning('Configura MySQL en la barra lateral y presiona **Conectar a MySQL** para cargar los módulos.'); st.stop()
try:
    cfg=st.session_state.db_cfg; engine=get_engine(cfg['host'],cfg['port'],cfg['user'],cfg['password'],cfg['db']); all_tables=tables(engine)
    if not all_tables: st.error('La base de datos no contiene tablas.'); st.stop()
except Exception as e: st.error(f'No se pudo leer el esquema MySQL: {e}'); st.stop()
can_edit=st.session_state.auth_role=='Administrador'
page=st.sidebar.radio('Navegación',['Inicio','Dashboard','Centros (CRUD)','Especies (CRUD)','Registro de visitantes','Explorador de tablas'])
if page=='Inicio':
    st.title('🌊 Sistema Integral de Gestión de Centros de Conservación Marina')
    st.write('PMV para centralizar información de centros, especies, visitantes y actividades de conservación.')
    st.success(f'Conectado a MySQL · Base: {cfg["db"]} · {len(all_tables)} tablas detectadas')
    st.markdown('### Módulos del sistema')
    st.markdown('- Dashboard e indicadores\n- Administración de centros de conservación\n- Administración de especies marinas\n- Registro transaccional de visitantes\n- Consultas y visualización de tablas')
    st.info('Administrador: acceso CRUD. Operador: consulta y registro transaccional.')
elif page=='Dashboard': dashboard(engine,all_tables)
elif page=='Centros (CRUD)':
    t=choose_table(all_tables,['centro']); crud_page(engine,t,can_edit,'🏢 Gestión de centros de conservación') if t else st.error('No se detectó tabla centro.')
elif page=='Especies (CRUD)':
    t=choose_table(all_tables,['especie_marina','especie']); crud_page(engine,t,can_edit,'🐬 Gestión de especies marinas') if t else st.error('No se detectó tabla de especies.')
elif page=='Registro de visitantes': registration(engine,all_tables)
elif page=='Explorador de tablas':
    st.title('🗂️ Explorador de tablas')
    t=st.selectbox('Tabla',all_tables)
    st.subheader(f'Estructura: {t}')
    st.dataframe(pd.DataFrame(get_columns(engine,t)),use_container_width=True)
    st.subheader('Datos'); st.dataframe(table_df(engine,t),use_container_width=True,hide_index=True)
