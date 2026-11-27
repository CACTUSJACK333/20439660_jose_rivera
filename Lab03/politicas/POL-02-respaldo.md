# POL-02 — Política de respaldo

**Objetivo:** Evitar la pérdida de información por fallas, errores humanos o problemas del servidor.

**Alcance:** Aplica a las bases de datos comercial de PostgreSQL y MongoDB, incluyendo sus tablas, colecciones y registros de auditoría.

**Regla:** Se deberá realizar un respaldo diario de la información y conservar copias en una ubicación segura diferente al servidor principal. El DBA deberá verificar periódicamente que los respaldos puedan utilizarse correctamente.

**Responsable:** El DBA ejecuta y verifica los respaldos. El responsable de TI supervisa su cumplimiento.

**Excepciones:** Cualquier cambio en la frecuencia de respaldo deberá ser autorizado por el responsable de TI.

**Evidencia:** Actualmente no se cuenta con evidencia de respaldos en los laboratorios realizados. El procedimiento técnico se definirá en la Unidad V.

**Revisión:** Cada tres meses.