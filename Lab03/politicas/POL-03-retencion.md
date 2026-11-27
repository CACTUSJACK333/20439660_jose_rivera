# POL-03 — Política de retención

**Objetivo:** Evitar que los datos y las bitácoras se conserven indefinidamente o se eliminen antes de tiempo.

**Alcance:** Aplica a los datos de clientes, bitácoras de PostgreSQL, registros de MongoDB y tablas de auditoría.

**Regla:** Los registros deberán conservarse de acuerdo con los periodos establecidos en `evidencias/05-conservacion.md`. Antes de eliminar información, se deberá verificar que no exista una investigación o revisión pendiente. Los datos personales deberán eliminarse o anonimizarse cuando corresponda, sin perder la evidencia necesaria para auditoría.

**Responsable:** El propietario del dato aprueba la conservación o eliminación. El DBA ejecuta las acciones correspondientes.

**Excepciones:** Los registros relacionados con investigaciones pendientes podrán conservarse por más tiempo con autorización del responsable correspondiente.

**Evidencia:** Archivo `evidencias/05-conservacion.md`, configuración de bitácoras de PostgreSQL y estado del perfilado de MongoDB documentado en el LAB-02.

**Revisión:** Cada seis meses.