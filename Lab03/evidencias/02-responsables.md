# Actividad 2 — Propietarios, custodios y usuarios

## Tabla de responsables

| Conjunto de datos | Propietario | Custodio | Usuarios autorizados | Quién aprueba accesos | Quién aprueba correcciones |
|---|---|---|---|---|---|
| `comercial.public.clientes` (PostgreSQL) | Gerencia Comercial | DBA | app_ventas y soporte_ana | Gerencia Comercial | Gerencia Comercial |
| `auditoria.cambios_clientes` (PostgreSQL) | Auditoría Interna | DBA | Auditoría Interna y personal autorizado | Responsable de Auditoría | Auditoría Interna |
| Bitácora de PostgreSQL | Seguridad y Auditoría | DBA | Auditoría Interna y DBA autorizado | Responsable de Seguridad | No aplica; se conserva como evidencia |
| `comercial.clientes` (MongoDB) | Gerencia Comercial | Administrador de MongoDB | Aplicación de ventas y soporte autorizado | Gerencia Comercial | Gerencia Comercial |
| `comercial.system.profile` (MongoDB) | Auditoría Interna | Administrador de MongoDB | DBA y Auditoría Interna | Responsable de Auditoría | No aplica; contiene registros de actividad |

## Preguntas

**1. ¿Por qué el propietario de `auditoria.cambios_clientes` no debería ser el mismo que opera `clientes`?**

Porque debe existir una separación de responsabilidades. Si la misma persona administra los datos y también controla su auditoría, podría modificar información y alterar las evidencias. Es mejor que Auditoría Interna supervise los registros de cambios.

**2. ¿Quién debería poder leer las bitácoras y la vista `dba.bitacora`? Relaciónalo con lo observado en el LAB-01 (secretos en la bitácora).**

Solamente el DBA autorizado y el personal de Auditoría o Seguridad que necesite revisar los registros. No todos los usuarios deben tener acceso porque las bitácoras pueden contener información personal y contraseñas escritas directamente en algunas sentencias, como ocurrió en el LAB-01.

**3. ¿Qué ocurre con la responsabilidad sobre un dato cuando nadie la tiene asignada? Relaciónalo con el problema inicial de la unidad.**

Cuando nadie es responsable de un dato, no existe una persona que autorice sus cambios, revise su calidad o decida cuándo debe corregirse. Esto puede provocar datos incorrectos, duplicados y modificaciones sin autorización. Por eso es importante asignar un propietario y un custodio para cada conjunto de datos.