PMV - Sistema Integral de Gestión de Centros de Conservación Marina


CONTENIDO
- app.py: aplicación Streamlit
- requirements.txt: dependencias Python
- Dockerfile y docker-compose.yml: despliegue en contenedor
- .env.example: plantilla de variable de contraseña


REQUISITOS
Python 3.10+ (recomendado 3.12), MySQL activo, base conservacion_marina existente.\n

EJECUCIÓN LOCAL (VS CODE)
1) Abre esta carpeta en VS Code.
2) En Terminal > New Terminal, ejecuta:
   python -m pip install -r requirements.txt
3) Ejecuta:
   python -m streamlit run app.py
4) Abre la URL que indique Streamlit (normalmente http://localhost:8501).
5) Login demo: Benjamin / 1234 o Operador / operador123.
6) En la barra lateral, completa conexión MySQL (host localhost, puerto 3306, usuario root, clave local y base conservacion_marina), luego Conectar.


DOCKER
1) Copia .env.example como .env y completa DB_PASSWORD.
2) Docker Desktop debe estar abierto y MySQL ejecutándose en el equipo anfitrión.
3) Desde esta carpeta ejecuta:
   docker compose up --build
4) Abre http://localhost:8501.

NOTAS IMPORTANTES
- La app no crea, borra ni altera el esquema de la base de datos.
- El CRUD se habilita en el rol Administrador; Operador es de consulta, pero tiene acceso al formulario de registro.
- El formulario de participación detecta tablas visitante y actividad y, si encuentra una tabla de relación con columnas compatibles, intenta insertar la relación dentro de una transacción.
- Los usuarios de demo son para presentación local, no para producción. Cambia las claves antes de desplegar públicamente.
- El registro transaccional depende de que el esquema existente tenga columnas compatibles. La aplicación detecta las tablas y muestra el explorador de esquema.
