# POL-01 — Política de acceso

**Objetivo:** Evitar accesos no autorizados a las bases de datos y proteger la información de los clientes.

**Alcance:** Aplica a PostgreSQL, MongoDB y a todos los usuarios que consulten o modifiquen información.

**Regla:** Todo acceso debe ser solicitado por el responsable del área y aprobado por el propietario del dato. El DBA otorgará únicamente los permisos necesarios para realizar las actividades autorizadas. Los permisos deberán revisarse cada tres meses.

**Responsable:** Gerencia Comercial aprueba los accesos a datos de clientes. El DBA ejecuta y revisa los permisos.

**Excepciones:** Los accesos de emergencia deberán ser autorizados por el responsable de TI y revisados posteriormente.

**Evidencia:** Bitácora de PostgreSQL con instrucciones GRANT y REVOKE del LAB-01, y las instantáneas de privilegios de MongoDB en `auditoria.instantaneas_privilegios`.

**Revisión:** Cada tres meses.