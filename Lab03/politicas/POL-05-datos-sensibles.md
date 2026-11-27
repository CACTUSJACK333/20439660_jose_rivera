# POL-05 — Política de uso de datos sensibles

**Objetivo:** Proteger los datos personales de los clientes y evitar su consulta o modificación sin autorización.

**Alcance:** Aplica a nombres, correos, teléfonos, RFC, edades y demás información personal almacenada en PostgreSQL y MongoDB.

**Regla:** Los usuarios solo podrán consultar los datos necesarios para cumplir sus funciones. El acceso a información sensible deberá contar con autorización del propietario del dato y quedar registrado. Los datos no deberán compartirse con personas no autorizadas.

**Responsable:** Gerencia Comercial autoriza el uso de los datos y el DBA aplica los controles de acceso.

**Excepciones:** El acceso extraordinario por motivos de auditoría o investigación deberá ser autorizado y documentado.

**Evidencia:** Vista de acceso para soporte y permisos del LAB-01, tabla `auditoria.cambios_clientes` e instantáneas de privilegios de MongoDB.

**Revisión:** Cada tres meses.