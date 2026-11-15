### Actividad 3 — Activar el perfilador y registrar operaciones
| **#** | **`op`** | **Usuario** | **Cliente** | **Aplicación** | **Momento** | **Qué hizo** | **Documentos afectados** |
|---|---|---|---|---|---|---|---|
| 1 | `query` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 15/11/2026 17:44:44 UTC y 17:46:07 UTC | Consultó los clientes cuya ciudad era Culiacán. | Examinó 5 documentos y devolvió 3. |
| 2 | `update` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 15/11/2026 17:46:10 UTC | Actualizó el RFC de María García (`_id: 3`) a `GAMA780912XYZ`. | Examinó 1 documento y modificó 1. |
| 3 | `remove` | `app_ventas@comercial` | `127.0.0.1` | `app-ventas-web` | 15/11/2026 17:46:22 UTC | Eliminó el documento de Carlos Pérez (`_id: 2`). | Examinó 1 documento y eliminó 1. |

#### Preguntas

**1. ¿Puedes saber cuál era el RFC antes del cambio con la información de `system.profile`?**

No directamente. El perfilador muestra el RFC nuevo que se estableció (`GAMA780912XYZ`), pero no guarda automáticamente el valor anterior. Para conocerlo se necesitaría otra evidencia, como una copia de seguridad o un registro de auditoría que almacene los valores anteriores y nuevos.

**2. ¿Puedes saber qué datos tenía el documento eliminado?**

No. El perfilador permite saber que se eliminó el documento con `_id: 2`, pero no muestra todos sus datos. Solamente registra información de la operación, como el filtro utilizado y la cantidad de documentos eliminados.

**3. A diferencia de `log_statement = 'mod'` en PostgreSQL, el nivel 2 sí registró la consulta. ¿Qué ventaja y qué riesgo tiene eso?**

La ventaja es que permite tener un registro más completo de las operaciones realizadas, incluyendo las consultas, actualizaciones y eliminaciones. Esto ayuda a investigar qué ocurrió en la base de datos.

El riesgo es que se genera una mayor cantidad de registros, lo que puede consumir espacio de almacenamiento y afectar el rendimiento del servidor. Además, algunas consultas pueden contener información sensible.

**4. ¿Por qué el campo `user` incluye `@comercial`?**

Porque MongoDB muestra el nombre del usuario junto con la base de datos donde está registrado. En este caso, `app_ventas` es el usuario y `comercial` es su base de autenticación.