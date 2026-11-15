## Actividad 1 — Lo que no existe en esta edición
### 1. ¿Qué edición de MongoDB estás usando? ¿Qué evidencia lo demuestra?

9.0.8. La evidencia es el resultado de `db.version()`, que mostró la versión 9.0.8.

### 2. ¿A dónde escribe tu servidor su bitácora? ¿Cómo lo sabes?

El servidor escribe su bitácora en el archivo:

`C:\Program Files\MongoDB\Server\9.0\log\mongod.log`

Lo comprobé mediante `db.serverCmdLineOpts().parsed`, donde aparece la sección `systemLog` con el destino `file` y la ruta del archivo. Esto demuestra que los registros del servidor se guardan en ese archivo.

### 3. Según REF-U3-04, ¿qué cuatro categorías de eventos registraría la auditoría nativa?

Las cuatro categorías son:

1. Cambios de esquema (DDL).
2. Eventos de réplica y fragmentación.
3. Autenticación y autorización.
4. Operaciones CRUD.

### 4. ¿Qué tendría que evaluar una organización antes de licenciar Enterprise o migrar a Atlas solo para obtener auditoría?

Antes de tomar esa decisión, una organización tendría que revisar cuánto le costaría adquirir y mantener la solución, qué tan importante es la auditoría para sus necesidades de seguridad y si realmente necesita todas las funciones que ofrecen Enterprise o Atlas.

También tendría que considerar los requisitos legales y de cumplimiento, el volumen de operaciones que necesita registrar, el espacio para almacenar los registros y el impacto que esto podría tener en el rendimiento.

En el caso de Atlas, además tendría que evaluar los costos del servicio en la nube, la migración de sus bases de datos y la seguridad de la información. No sería conveniente hacer el cambio solamente por obtener auditoría sin comparar primero los beneficios, los costos y otras alternativas disponibles.