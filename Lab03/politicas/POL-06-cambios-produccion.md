# POL-06 — Política de cambios en producción

**Objetivo:** Evitar modificaciones no autorizadas que puedan afectar la información o el funcionamiento de las bases de datos.

**Alcance:** Aplica a cualquier cambio realizado en los ambientes de desarrollo, pruebas y producción de PostgreSQL y MongoDB.

**Regla:** Todo cambio en producción deberá contar con una solicitud documentada y aprobada antes de ejecutarse. El DBA deberá realizarlo dentro de la ventana autorizada, registrar las operaciones y verificar que el sistema funcione correctamente después del cambio.

**Responsable:** El Comité de cambios aprueba las modificaciones y el DBA las ejecuta y documenta.

**Excepciones:** Los cambios urgentes deberán ser autorizados por el responsable de TI y documentados posteriormente.

**Evidencia:** Bitácora de PostgreSQL con instrucciones ALTER, GRANT y REVOKE del LAB-01. El registro formal de solicitudes autorizadas se incorporará mediante `gobierno.solicitudes_cambio` en la Actividad 7.

**Revisión:** Cada tres meses.