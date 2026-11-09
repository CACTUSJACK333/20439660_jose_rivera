# Informe — Laboratorio 1: Bitácoras y auditoría del dato en PostgreSQL

## 1. Despliegue y situación inicial

Para realizar este laboratorio utilicé PostgreSQL 16 instalado localmente en Windows 10. El servidor se encontraba trabajando en el puerto 5432 y utilicé pgAdmin para ejecutar las consultas y administrar la base de datos `comercial`.

Al principio, PostgreSQL ya generaba registros de actividad, pero la configuración inicial no permitía conocer con suficiente detalle todos los cambios realizados en los datos. Por ejemplo, el parámetro `log_statement` estaba configurado para registrar principalmente instrucciones de definición de estructura, por lo que no era suficiente para reconstruir modificaciones realizadas en los registros de la tabla `clientes`.

Esto representaba un problema porque, si Dirección solicitaba saber quién había modificado un RFC, cuándo lo hizo y cuál era su valor anterior, no siempre existía información suficiente para responder.

## 2. Configuración aplicada

Durante el laboratorio se modificó la configuración de PostgreSQL para mejorar el registro de las operaciones.

Uno de los cambios principales fue configurar:

alter system set log_statement = 'mod';

Con este ajuste, PostgreSQL comenzó a registrar sentencias que modifican información, como INSERT, UPDATE y DELETE, además de las instrucciones de definición de estructura.

Posteriormente se comprobó la configuración mediante:

show log_statement;

También se trabajó con la configuración del registro del servidor para identificar datos como el usuario, la base de datos, la aplicación y la dirección del cliente.

Los cambios realizados mediante `ALTER SYSTEM` se guardaron en el archivo de configuración correspondiente. Para parámetros que permiten recarga se utilizó `pg_reload_conf()`. Los parámetros que requieren reiniciar el servidor necesitan un reinicio para aplicar el cambio.

En este laboratorio también se creó una tabla de auditoría y un trigger para registrar los cambios realizados sobre la tabla `clientes`.

## 3. Eventos observados

Durante la revisión de las bitácoras se encontraron diferentes tipos de eventos:

**Intentos de conexión fallidos:** se encontraron intentos de autenticación fallidos de `app_ventas`, `soporte_ana` y `usuario_inexistente`. Por ejemplo, `app_ventas` presentó un error de contraseña incorrecta desde la dirección local `127.0.0.1`.

**Cambios de permisos:** se encontró que el usuario `postgres` revocó el permiso UPDATE a `soporte_ana` y posteriormente concedió ese permiso a `app_ventas`.

**Modificaciones de datos:** se encontró una actualización del teléfono del cliente con ID 3, realizada mediante la aplicación `app-ventas-web`.

**Operaciones rechazadas:** el usuario `soporte_ana` intentó eliminar al cliente con ID 5, pero PostgreSQL rechazó la operación porque no tenía permisos suficientes.

**Cambios de estructura:** se registró la creación de la columna `segmento` en la tabla `clientes`.

**Cambios relacionados con la auditoría:** también se observó que el administrador desactivó temporalmente el trigger, modificó el RFC del cliente 3 y después volvió a activar el trigger.

Estos ejemplos muestran que la bitácora permite conocer tanto las operaciones exitosas como los intentos que fueron rechazados.

## 4. Auditoría del dato

Se creó la tabla `auditoria.cambios_clientes` para guardar información de las modificaciones realizadas en la tabla `clientes`.

Entre los datos registrados se encuentran:

- Identificador del evento.
- Fecha y hora.
- Usuario de sesión.
- Usuario efectivo.
- Aplicación utilizada.
- Dirección IP del cliente.
- Tipo de operación.
- Identificador del cliente modificado.
- Valores anteriores.
- Valores nuevos.

El trigger se encargó de registrar automáticamente los cambios realizados sobre los registros de clientes.

También se utilizó `SECURITY DEFINER` en la función de auditoría. Esto permite que la función se ejecute con los permisos de su propietario, en lugar de depender de todos los permisos del usuario que realiza la operación.

Por otro lado, `session_user` permite identificar al usuario que inició la conexión, mientras que `current_user` permite conocer el usuario efectivo con el que se está ejecutando la función.

Esto fue importante porque en uno de los registros apareció `app_ventas` como usuario de sesión y `postgres` como usuario efectivo. Así se pudo identificar qué cuenta inició la operación aunque la función de auditoría se ejecutara con los permisos de su propietario.

En el incidente del RFC del cliente 3 se registró un cambio de `GAMA780912XYZ` a `GAMA780912ZZZ`, realizado por `app_ventas` desde la aplicación `app-ventas-web`.

Después se encontró otro cambio, de `GAMA780912ZZZ` a `GAMA780912GHI`, realizado por `postgres` mientras el trigger estaba desactivado. Este segundo cambio apareció en la bitácora del servidor, pero no en la tabla de auditoría.

## 5. Limitaciones

Aunque la configuración permitió obtener más información, también se encontraron algunas limitaciones.

Una de ellas es que `log_statement = 'mod'` registra modificaciones, pero no todas las consultas de lectura. Por lo tanto, no permite conocer por sí solo todas las consultas SELECT que realizaron los usuarios.

Otra limitación es que la cantidad de registros puede crecer considerablemente, especialmente cuando existen muchas operaciones sobre las tablas.

También se comprobó que un administrador con permisos suficientes puede modificar la configuración del servidor o desactivar un trigger. Esto significa que la auditoría dentro de la misma base de datos no es completamente independiente de los administradores.

Además, las consultas para leer directamente los archivos de bitácora presentaron problemas de codificación UTF-8 porque los archivos estaban generados con una codificación diferente.

## 6. Riesgos de la bitácora

Las bitácoras pueden contener información sensible, por lo que también necesitan protección.

Durante el laboratorio se encontró una sentencia que contenía una contraseña escrita directamente en el comando de creación de un rol temporal. Esto representa un riesgo porque una persona que tenga acceso al archivo podría conocer esa contraseña.

También pueden quedar registrados nombres, RFC, teléfonos, correos electrónicos y direcciones IP.

Otro riesgo es que los archivos sean eliminados, modificados o copiados por personas que no deberían tener acceso a ellos.

Para reducir estos riesgos es necesario limitar los permisos de lectura, proteger los archivos, conservar respaldos y evitar registrar contraseñas u otros secretos directamente en las sentencias.

## 7. Cronología y conclusión

Al reconstruir los eventos fue posible identificar varios cambios importantes realizados durante el laboratorio.

El cambio del RFC del cliente 3 realizado por `app_ventas` quedó registrado tanto en la bitácora como en la tabla de auditoría. Se pudo conocer el usuario, la hora, la aplicación, la dirección IP y el valor anterior del RFC.

Sin embargo, el segundo cambio realizado por `postgres` no quedó registrado en la tabla de auditoría porque el trigger estaba desactivado. En este caso, la bitácora del servidor permitió recuperar la sentencia ejecutada.

También hubo eventos anteriores para los que no existía suficiente información, por lo que no fue posible reconstruirlos completamente.

En conclusión, con esta configuración se puede demostrar quién cambió un dato sensible y qué valor tenía antes, siempre que la auditoría estuviera activa y funcionando al momento del cambio. Sin embargo, no se puede garantizar que todos los cambios queden registrados si un administrador tiene la posibilidad de modificar o desactivar los mecanismos de auditoría.

# Preguntas de reflexión

## 1. ¿Por qué la auditoría no puede configurarse después de un incidente para investigarlo?

Porque la auditoría solamente puede registrar los eventos que ocurren después de estar configurada. Si un cambio se realizó antes de activar los registros, posiblemente no exista información sobre quién lo hizo, cuándo ocurrió o cuál era el valor anterior. Por eso es importante preparar la auditoría antes de que suceda un problema.

## 2. ¿Por qué conviene que la bitácora la administre el propio servidor y no el mecanismo de despliegue?

Porque el servidor es quien conoce las operaciones que realmente se ejecutan, los usuarios que se conectan y los errores que ocurren. Si la bitácora dependiera solamente del mecanismo de despliegue, podría no registrar operaciones realizadas directamente desde pgAdmin, psql u otras aplicaciones. Por eso conviene que PostgreSQL genere sus propios registros.

## 3. ¿Por qué el prefijo de línea es tan importante como el nivel de log_statement?

Porque `log_statement` determina qué sentencias se registran, mientras que el prefijo permite identificar quién las ejecutó, desde qué aplicación, en qué momento y desde qué dirección. Si solamente se guarda la sentencia sin información de contexto, sería mucho más difícil relacionarla con un usuario o una conexión específica.

## 4. ¿Qué diferencia práctica hay entre registrar la sentencia y registrar el cambio en el dato?

Registrar la sentencia permite conocer qué instrucción se ejecutó, por ejemplo, un UPDATE sobre un cliente. Sin embargo, no siempre permite conocer fácilmente cuáles eran todos los valores anteriores y cuáles quedaron después de la modificación.

La auditoría del dato guarda directamente los valores anteriores y nuevos, junto con información del usuario y la operación. Esto facilita reconstruir exactamente qué cambió en un registro.

## 5. ¿Qué evidencia ofrece pg_stat_activity que no ofrece la bitácora, y viceversa?

`pg_stat_activity` permite observar las conexiones y actividades que están ocurriendo en ese momento, como el usuario conectado, la aplicación, la consulta en ejecución y el estado de la sesión.

La bitácora, en cambio, conserva registros de eventos que ya ocurrieron, por lo que permite revisar operaciones pasadas, errores e intentos de conexión que ya terminaron.

La principal diferencia es que `pg_stat_activity` sirve para observar la actividad actual, mientras que la bitácora permite reconstruir eventos anteriores.

## 6. Si el administrador puede cambiar log_statement a none y desactivar el disparador, ¿quién audita al administrador?

Lo ideal es que la auditoría del administrador sea responsabilidad de un mecanismo independiente del propio administrador. Por ejemplo, se pueden enviar las bitácoras a un servidor externo donde el administrador de PostgreSQL no tenga permisos para modificarlas o eliminarlas.

También se pueden utilizar herramientas de monitoreo y auditoría administradas por otro equipo. De esta manera, aunque el administrador pueda modificar los registros locales o desactivar un trigger, sus acciones pueden quedar registradas en otro sistema.

Esto demuestra que no es suficiente con auditar a los usuarios normales; también es necesario tener controles sobre las acciones de los administradores.