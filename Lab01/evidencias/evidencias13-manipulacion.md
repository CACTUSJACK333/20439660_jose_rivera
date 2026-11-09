### Actividad 14 — Intentar manipular la auditoría

**1. ¿Qué evidencia permite detectar que hubo un cambio sin auditar?**

La evidencia se encuentra en la bitácora del servidor PostgreSQL. Ahí se pueden identificar las instrucciones utilizadas para desactivar y volver a activar el disparador, además de la sentencia UPDATE que modificó el RFC. Aunque ese cambio no apareció en la tabla de auditoría, la bitácora permite detectar que el mecanismo fue desactivado.

**2. ¿Qué control administrativo (no técnico) reduciría este riesgo?**

Una medida sería separar las responsabilidades entre las personas que administran la base de datos y las que revisan la auditoría. También se deberían establecer autorizaciones para realizar cambios importantes, llevar un registro de quién los aprobó y revisar periódicamente las bitácoras.

**3. Relaciona esta actividad con el principio de separación de funciones de la Unidad II.**

Esta actividad demuestra que no es conveniente que una misma persona tenga control sobre los datos y sobre sus registros de auditoría. Si alguien puede modificar la información y también borrar las evidencias, podría ocultar sus acciones. Por eso, las funciones deben estar separadas y la auditoría debe ser revisada y protegida por personal diferente al que administra las operaciones.