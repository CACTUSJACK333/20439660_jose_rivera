# Actividad 4. Catálogo mínimo de datos

## 1. Inventario de conjuntos de datos

| ID | Conjunto de datos | Motor | Ubicación | Registros | Tamaño |
|---|---|---|---|---:|---|
| CAT-01 | Clientes | PostgreSQL 16 | comercial.public.clientes | 7 | 24 kB |
| CAT-02 | Auditoría de clientes | PostgreSQL 16 | comercial.auditoria.cambios_clientes | 12 | 64 kB |
| CAT-03 | Solicitudes de cambio | PostgreSQL 16 | comercial.gobierno.solicitudes_cambio | Pendiente de creación | — |
| CAT-04 | Clientes de la tienda | MongoDB 9.0.8 | comercial.clientes | 4 | No consultado |
| CAT-05 | Perfilado de operaciones | MongoDB 9.0.8 | comercial.system.profile | 4 | No consultado |
| CAT-06 | Instantáneas de privilegios | MongoDB 9.0.8 | auditoria.instantaneas_privilegios | 2 | No consultado |

## 2. Catálogo de gobierno de datos

| ID | Propietario | Custodio | Clasificación | Datos personales | Finalidad | Conservación |
|---|---|---|---|---|---|---|
| CAT-01 | Gerencia Comercial | DBA | Confidencial | Sí | Administrar información de clientes | Según política de conservación |
| CAT-02 | Gerencia de TI | DBA | Confidencial | Sí | Registrar cambios realizados a los clientes | Según política de auditoría |
| CAT-03 | Gerencia Comercial | DBA | Interno | Puede contenerlos | Dar seguimiento a solicitudes de cambio | Según política de conservación |
| CAT-04 | Gerencia Comercial | Administrador MongoDB | Confidencial | Sí | Administrar clientes de la tienda | Según política de conservación |
| CAT-05 | Gerencia de TI | Administrador MongoDB | Confidencial | Puede contenerlos | Registrar operaciones realizadas en MongoDB | Según política de bitácoras |
| CAT-06 | Gerencia de TI | Administrador MongoDB | Interno | No directamente | Conservar evidencia de usuarios y privilegios | Según política de seguridad |

## 3. Observaciones técnicas

- PostgreSQL cuenta con 7 registros estimados en la tabla clientes y 12 en cambios_clientes.
- MongoDB cuenta con 4 documentos en clientes.
- La colección system.profile contiene 4 registros.
- El perfilado de MongoDB se encuentra desactivado actualmente.
- La colección instantaneas_privilegios contiene 2 documentos con información de usuarios y roles.
- La tabla gobierno.solicitudes_cambio queda pendiente de creación o verificación en la siguiente actividad.

## 4. Preguntas

**1. ¿Por qué CAT-02 y CAT-05 contienen datos personales aunque su propósito sea la auditoría?**

Porque al registrar operaciones pueden guardar información relacionada con los clientes, como identificadores, RFC, consultas o cambios realizados. Aunque su finalidad sea auditar, deben protegerse porque pueden contener datos personales.

**2. ¿Qué pasa si CAT-01 y CAT-04 tienen propietarios distintos y el RFC de un cliente difiere entre ambos motores?**

Se puede generar información inconsistente. Por eso debe existir un responsable que determine cuál dato es correcto y coordine la actualización de ambos motores para mantener la información sincronizada.

**3. ¿Qué información del catálogo cambia con más frecuencia y quién debe actualizarla?**

La ubicación, cantidad de registros, clasificación y finalidad pueden cambiar conforme evoluciona el sistema. El DBA debe actualizar la información técnica y los propietarios de los datos deben informar sobre cambios en su uso, clasificación o conservación.