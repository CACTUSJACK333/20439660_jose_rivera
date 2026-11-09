# Actividad 4 — Preguntas de análisis

### 1. ¿Por qué el proceso que registra el cambio es el principal y no tu sesión?

Porque el proceso principal de PostgreSQL es el encargado de administrar y registrar los cambios de configuración del servidor. Aunque nosotros ejecutemos una instrucción desde nuestra sesión, quien realmente aplica el cambio es PostgreSQL. Por eso es importante identificar el proceso responsable y no solamente la sesión desde donde se ejecutó el comando.

### 2. ¿Qué pasaría si alguien ejecutara `ALTER SYSTEM SET log_statement = 'none'`? ¿Quedaría rastro?

Al ejecutar esa instrucción, PostgreSQL dejaría de registrar las sentencias SQL en la bitácora una vez que se aplique la nueva configuración. Sin embargo, el cambio de configuración podría quedar registrado si existen mecanismos de auditoría o registros que capturen ese tipo de operaciones. Por eso es importante proteger los permisos para modificar la configuración del servidor.

### 3. ¿Por qué no se recomienda editar `postgresql.auto.conf` a mano?

Porque ese archivo es administrado por PostgreSQL y almacena los cambios realizados mediante `ALTER SYSTEM`. Si lo modificamos manualmente podemos cometer errores en su formato o provocar conflictos con la configuración. Lo recomendable es utilizar las instrucciones SQL correspondientes para que PostgreSQL administre esos cambios correctamente.