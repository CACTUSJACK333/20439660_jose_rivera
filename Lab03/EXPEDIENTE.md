# Expediente de auditoría interna 
**Materia:** Gestión de Seguridad y Desempeño de Bases de Datos  
**Unidad:** III — Auditoría, trazabilidad y gobierno práctico de datos  
**Base de datos:** `comercial`  
**Periodo revisado:** 2 al 25 de noviembre de 2026  
**Responsable del expediente:** Estudiante responsable de las prácticas  
**Sistemas revisados:** PostgreSQL 16 y MongoDB Community 9.0.8  
**Entorno:** Windows 10, instalaciones locales.

---

## 1. Alcance

Este expediente reúne las evidencias de auditoría, trazabilidad y gobierno de datos de la base `comercial`, utilizando los resultados de los laboratorios LAB-01, LAB-02 y LAB-03.

Se revisaron los mecanismos de registro de PostgreSQL, los disparadores de auditoría, los privilegios de acceso, la trazabilidad de operaciones en MongoDB, la calidad de los datos y el registro de cambios.

El periodo revisado comprende del 2 al 25 de noviembre de 2026, de acuerdo con las fechas de las evidencias disponibles.

El objetivo es identificar qué operaciones se realizaron, qué controles existen, cuáles cambios cuentan con autorización y qué aspectos necesitan seguimiento.

## 2. Configuración de auditoría (A3)

### PostgreSQL

La configuración actual de registro presenta los siguientes valores:

| Parámetro | Valor | Interpretación |
|---|---|---|
| `logging_collector` | on | Recopilación de registros habilitada. |
| `log_connections` | on | Registro de conexiones habilitado. |
| `log_disconnections` | on | Registro de desconexiones habilitado. |
| `log_line_prefix` | `%m [%p] user=%u db=%d app=%a client=%h` | Registra fecha, proceso, usuario, base, aplicación y cliente. |
| `log_min_error_statement` | error | Registra sentencias asociadas a errores de nivel error o superior. |
| `log_statement` | mod | Registra sentencias que modifican datos. |

La configuración fue consultada directamente mediante `pg_settings`. Cinco parámetros provienen del archivo de configuración y `log_min_error_statement` conserva el valor predeterminado.

**Evidencia:** `evidencias/E1-configuracion-registro.txt`.

El mecanismo de auditoría de cambios de datos utiliza el disparador `trg_auditoria_clientes`, asociado a la tabla `clientes`.

En la consulta actual, el disparador aparece con `tgenabled = O`, lo que significa que se encuentra habilitado para la operación normal.

**Evidencia:** `evidencias/E3-disparadores.txt`.

### MongoDB

En MongoDB se utilizaron el perfilador (`system.profile`) y la bitácora del servidor (`mongod`). El archivo exportado del perfilador contiene cuatro registros de operaciones, mientras que la bitácora permite revisar eventos del servidor.

La comparación del LAB-02 documenta que MongoDB Community no proporcionó auditoría nativa de cambios de privilegios y estructura en esta práctica. Se utilizó la comparación de instantáneas como control compensatorio para los privilegios.

**Evidencias:**
- `evidencias/E6-mongodb/system-profile.json`
- `evidencias/E6-mongodb/bitacora-mongod.log`
- `evidencias/E6-mongodb/09-comparacion.md`

## 3. Bitácora interpretada (A3, A5)

### Evento 1. Modificación del RFC de un cliente

- **Fecha y hora:** 2 de noviembre de 2026, 13:59:06.
- **Usuario:** `app_ventas`.
- **Aplicación:** `app-ventas-web`.
- **Origen:** `127.0.0.1`.
- **Operación:** `UPDATE`.
- **Cliente:** ID 3.
- **RFC anterior:** `GAMA780912XYZ`.
- **RFC nuevo:** `GAMA780912ZZZ`.
- **Tipo de evento:** Modificación de dato personal.

El disparador de auditoría registró el cambio del RFC del cliente identificado como María García. Se conservaron tanto el valor anterior como el nuevo, lo que permite conocer qué información fue modificada.

Este evento demuestra la utilidad de la auditoría para investigar cambios en datos personales. Sin embargo, el registro por sí solo no demuestra que el nuevo RFC sea correcto ni que la modificación haya sido autorizada por el propietario del dato.

**Evidencia:** registro `id_evento = 1` de `auditoria.cambios_clientes`, consultado en PostgreSQL durante el LAB-01.

### Evento 2. Desactivación del disparador de auditoría

- **Fecha y hora:** 2 de noviembre de 2026, 14:21:04 aproximadamente.
- **Usuario:** `app_ventas`.
- **Aplicación:** `app-ventas-web`.
- **Origen:** `127.0.0.1`.
- **Operación:** `ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes`.
- **Tipo de evento:** Cambio de configuración del mecanismo de auditoría.

La bitácora registró una sentencia para desactivar el disparador de auditoría de la tabla `clientes`. Esto representa un riesgo porque, mientras el disparador permanece deshabilitado, las modificaciones realizadas en la tabla pueden dejar de generar registros en `auditoria.cambios_clientes`.

En una revisión posterior se encontró el disparador habilitado nuevamente. Esto demuestra su estado actual, pero no elimina el riesgo del periodo durante el cual estuvo desactivado.

No se identificó un folio de autorización asociado a esta operación en la conciliación realizada.

**Evidencia:** `evidencias/06-conciliacion.md` y registro histórico localizado en `postgresql-2026-11-02_000000.log`. El archivo histórico completo no forma parte del paquete E5 actual.

### Evento 3. Cambio autorizado de estructura

- **Folio:** `CAM-2026-014`.
- **Fecha y hora de ejecución:** 25 de noviembre de 2026, 22:02:59 aproximadamente.
- **Usuario:** `postgres`.
- **Aplicación:** `pgAdmin 4`.
- **Origen:** `::1`.
- **Operación:** `ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20)`.
- **Tipo de evento:** Cambio de estructura en producción.

La solicitud fue registrada por Gerencia Comercial y aprobada por el Comité de cambios. La consulta de verificación indicó que la ejecución se encontraba dentro de la ventana autorizada.

También se agregó un comentario a la nueva columna para relacionarla con el folio `CAM-2026-014`.

Este evento representa un cambio documentado y conciliado con una solicitud de autorización.

**Evidencias:**
- `evidencias/06-conciliacion.md`
- `evidencias/E5-bitacora-postgresql.log`
- Registro `CAM-2026-014` de `gobierno.solicitudes_cambio`.

## 4. Elementos de gobierno (A1, A2)

### Responsables

Se establecieron los siguientes responsables propuestos para el gobierno de los datos:

| Figura | Responsable | Función |
|---|---|---|
| Propietario del dato | Gerencia Comercial | Decide el uso, acceso y corrección de los datos. |
| Custodio | DBA | Administra y protege la información. |
| Usuarios | Aplicación de ventas y soporte | Consultan o modifican datos según sus permisos. |

El DBA actúa como custodio y no como propietario del dato. Por ello, una corrección de información personal debe contar con la decisión del responsable del área.

**Evidencia:** `evidencias/02-responsables.md`.

### Catálogo de datos

Se identificaron los siguientes conjuntos de datos:

- CAT-01: `public.clientes`, en PostgreSQL.
- CAT-02: `auditoria.cambios_clientes`, en PostgreSQL.
- CAT-03: `gobierno.solicitudes_cambio`, en PostgreSQL.
- CAT-04: colección `clientes`, en MongoDB.
- CAT-05: colección `system.profile`, en MongoDB.
- CAT-06: `auditoria.instantaneas_privilegios`, en MongoDB.

El catálogo registra la ubicación, finalidad, clasificación y responsables propuestos de los conjuntos de datos.

**Evidencia:** `evidencias/04-catalogo.md`.

### Diccionario de datos

Se documentó la estructura de la tabla `public.clientes`, incluyendo nombres de columnas, tipos de datos, restricciones y significado de negocio. También se agregaron comentarios a la tabla y sus columnas mediante `COMMENT`.

El diccionario permite identificar qué información se almacena y cuáles campos requieren mayor protección.

**Evidencias:**
- `evidencias/03-diccionario.md`
- `evidencias/diccionario-clientes.csv`

## 5. Conservación (A3)

Se propusieron los siguientes periodos de conservación para los registros:

| Tipo de registro | Periodo propuesto |
|---|---|
| Bitácoras de acceso de PostgreSQL | 90 días |
| Cambios DDL y privilegios | 1 año |
| Modificaciones de datos | 1 año |
| Tabla de auditoría | 1 año |
| Bitácoras de MongoDB | 90 días |
| `system.profile` | 7 días |
| Instantáneas de privilegios | 1 año |

Estos plazos son criterios propuestos para la práctica y no se presentan como obligaciones legales verificadas. Su aprobación definitiva corresponde a los responsables de gobierno de datos, considerando las necesidades operativas y normativas aplicables.

**Evidencia:** `evidencias/05-conservacion.md`.

## 6. Políticas (A4)

Se redactaron seis políticas prácticas para establecer reglas de acceso, protección y administración de la información:

| Política | Tema | Archivo |
|---|---|---|
| POL-01 | Acceso | `politicas/POL-01-acceso.md` |
| POL-02 | Respaldo | `politicas/POL-02-respaldo.md` |
| POL-03 | Retención | `politicas/POL-03-retencion.md` |
| POL-04 | Restauración | `politicas/POL-04-restauracion.md` |
| POL-05 | Uso de datos sensibles | `politicas/POL-05-datos-sensibles.md` |
| POL-06 | Cambios en producción | `politicas/POL-06-cambios-produccion.md` |

Las políticas establecen las reglas y responsabilidades que deben seguirse. Su documentación no significa que todos los controles técnicos estén implementados o automatizados.

**Evidencias:** archivos individuales dentro de la carpeta `politicas/`.

## 7. Conciliación de cambios (A5)

Se compararon los cambios registrados en las bitácoras con las solicitudes de autorización disponibles.

| Cambio | Autorización | Resultado |
|---|---|---|
| Agregar columna `canal_alta` | CAM-2026-014 | Autorizado y dentro de la ventana. |
| Desactivar `trg_auditoria_clientes` | Sin folio identificado | Requiere revisión. |
| `GRANT UPDATE` a `app_ventas` | Sin folio identificado en la conciliación | Requiere revisión documental. |
| `REVOKE UPDATE` a `soporte_ana` | Sin folio identificado en la conciliación | Requiere revisión documental. |

La consulta de privilegios actual mostró que `app_ventas` tiene permisos `SELECT` y `UPDATE` sobre `clientes`, mientras que `soporte_ana` tiene únicamente `SELECT`. Estos resultados coinciden con la matriz de roles esperada.

Sin embargo, la coincidencia de los permisos actuales no sustituye la evidencia de autorización de los cambios históricos.

La desactivación del disparador representa el cambio de mayor riesgo porque puede dejar operaciones sin registrar. Los cambios de privilegios también requieren conservar su solicitud y aprobación.

**Evidencias:**
- `evidencias/06-conciliacion.md`
- `evidencias/E2-privilegios.txt`
- `evidencias/E3-disparadores.txt`
- `evidencias/E5-bitacora-postgresql.log`

## 8. Hallazgos

| ID | Hallazgo | Fuente | Severidad | Impacto | Recomendación | Decisión requerida de |
|---|---|---|---|---|---|---|
| H-01 | Se encontraron problemas de calidad: correo duplicado normalizado, correo inválido, RFC faltante y edad negativa. | `evidencias/01-calidad.md` | Media | Puede afectar la confiabilidad de los datos de clientes. | Revisar y corregir los registros con autorización del propietario. | Gerencia Comercial |
| H-02 | Se encontró una operación para desactivar el disparador de auditoría sin folio identificado. | `evidencias/06-conciliacion.md` | Alta | Puede provocar pérdida de trazabilidad de modificaciones. | Investigar el motivo, documentar la autorización y restringir quién puede desactivarlo. | Comité de cambios y Gerencia Comercial |
| H-03 | Se identificaron cambios de privilegios sin folio asociado en la conciliación. | `evidencias/06-conciliacion.md` | Media | No se puede demostrar completamente la autorización histórica. | Vincular los cambios con solicitudes aprobadas y revisar periódicamente los privilegios. | Propietario del dato |
| H-04 | La configuración actual utiliza `log_statement = mod`, por lo que no registra consultas SELECT. | `evidencias/E1-configuracion-registro.txt` | Media | No existe evidencia completa de lecturas de datos sensibles mediante esta configuración. | Evaluar mecanismos adicionales de auditoría de consultas. | DBA y responsable de seguridad |

Los hallazgos se mantienen documentados aunque posteriormente se corrijan. Su cierre debe contar con evidencia de la acción realizada y de la persona que la autorizó.

## 9. Limitaciones conocidas y riesgos aceptados (A6)

Durante las prácticas se identificaron las siguientes limitaciones:

1. **MongoDB Community:** la comparación del LAB-02 mostró que no se contó con auditoría nativa de privilegios y estructura. La auditoría nativa de MongoDB Enterprise/Atlas se documentó como alternativa, pero no se practicó.

2. **Lecturas en PostgreSQL:** con `log_statement = mod` no se registran consultas SELECT. Por lo tanto, no se puede demostrar cada lectura de información sensible.

3. **Desactivación de triggers:** el disparador de auditoría puede ser desactivado por usuarios con privilegios suficientes. Su estado actual habilitado no demuestra que haya permanecido activo durante todo el periodo.

4. **Configuración histórica:** E1 representa una consulta de la configuración vigente al momento de obtener la evidencia. No demuestra por sí sola que esos valores hayan permanecido iguales durante todo el periodo revisado.

5. **Perfilador de MongoDB:** se encontraron registros históricos en `system.profile`, aunque en una consulta de estado el perfilador apareció deshabilitado. Por ello, no debe suponerse que estuvo activo permanentemente.

6. **Conservación:** los plazos documentados son propuestas y requieren aprobación formal. No se verificó su cumplimiento durante un periodo prolongado.

7. **Bitácoras:** la exportación de PostgreSQL presentó un problema de codificación UTF-8 al intentar leerla desde el motor. Se obtuvo una copia directa del archivo del sistema, que debe revisarse y redactarse antes de su entrega definitiva.

La aceptación formal de estos riesgos debe corresponder al propietario del dato, al Comité de cambios o al responsable de seguridad, según el tipo de riesgo. El DBA debe documentarlos y proponer medidas de mitigación.

## 10. Índice de evidencias

| Evidencia | Archivo | Descripción |
|---|---|---|
| A1 | `evidencias/01-calidad.md` | Resultados de calidad de datos. |
| A2 | `evidencias/02-responsables.md` | Matriz de responsables. |
| A3 | `evidencias/03-diccionario.md` | Diccionario de datos. |
| A4 | `evidencias/04-catalogo.md` | Catálogo mínimo de datos. |
| A5 | `evidencias/05-conservacion.md` | Criterios de conservación. |
| A6 | `evidencias/06-conciliacion.md` | Conciliación de cambios. |
| E1 | `evidencias/E1-configuracion-registro.txt` | Configuración de registro de PostgreSQL. |
| E2 | `evidencias/E2-privilegios.txt` | Privilegios actuales. |
| E3 | `evidencias/E3-disparadores.txt` | Estado actual del disparador. |
| E4 | `evidencias/E4-muestra-auditoria.txt` | Muestra de los últimos eventos de auditoría. |
| E5 | `evidencias/E5-bitacora-postgresql.log` | Bitácora exportada de PostgreSQL. |
| E5-H | `evidencias/E5-bitacora-postgresql.sha256` | Hash SHA-256 de la bitácora, pendiente de guardar como archivo. |
| E6-1 | `evidencias/E6-mongodb/system-profile.json` | Exportación del perfilador de MongoDB. |
| E6-2 | `evidencias/E6-mongodb/bitacora-mongod.log` | Bitácora del servidor MongoDB. |
| E6-3 | `evidencias/E6-mongodb/hashes.sha256` | Hashes registrados de archivos MongoDB. |
| E6-4 | `evidencias/E6-mongodb/09-comparacion.md` | Comparación de los mecanismos de auditoría. |

### Hashes SHA-256 registrados

**E5 — Bitácora PostgreSQL (copia actual, antes de cualquier redacción):**

`FF5D118C64082485DDFEC5A5A65A41D9F4C9A20B8062A331078665DF64069902`

**E6 — MongoDB:**

- `system-profile.json`: `9CC5ADDE3287C9B101964FCFCDE5931BF28DE72C0D8D36A4187FCAFF5373653`
- `bitacora-mongod.log`: `69CD0B851FC8B9B2632857CECCAA3502B68A2F5F1D2A70E5CA4F751B16786E28`

El archivo `hashes.sha256` también menciona `mongod-completo.log`, pero ese archivo no se encontró dentro del paquete E6 recibido.

**Nota de integridad:** si se modifica o redacta cualquier bitácora, debe calcularse nuevamente su hash y actualizarse el archivo correspondiente. El hash de E5 indicado arriba corresponde a la copia original, no a una versión redactada.

---

**Conclusión**

La integración de las evidencias permitió relacionar los mecanismos técnicos de auditoría con las políticas y responsabilidades de gobierno de datos. Se comprobó que existen registros de modificaciones, controles de acceso y solicitudes de cambio autorizadas. También se identificaron riesgos, principalmente la desactivación del disparador de auditoría y los problemas de calidad de algunos registros.

El expediente permite conocer qué controles existen, qué situaciones requieren revisión y qué decisiones deben tomar los responsables de los datos para mejorar la seguridad y trazabilidad de la base comercial.