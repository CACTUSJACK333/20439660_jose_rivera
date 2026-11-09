# Actividad 10 — Diseñar y crear el registro de auditoría


| **Campo propuesto** | **Tipo** | **¿Qué pregunta responde?** | **¿Puede ser nulo? ¿Por qué?** |
|---|---|---|---|
| `id_evento` | `BIGSERIAL` | ¿Cuál es el identificador único del evento? | No, porque identifica cada registro de auditoría. |
| `momento` | `TIMESTAMPTZ` | ¿En qué fecha y hora ocurrió el cambio? | No, porque es necesario conocer cuándo ocurrió el evento. |
| `usuario_sesion` | `TEXT` | ¿Con qué usuario se inició la sesión? | No, porque permite identificar quién se conectó. |
| `usuario_efectivo` | `TEXT` | ¿Qué usuario ejecutó realmente la operación? | No, porque permite identificar al usuario que realizó la acción. |
| `aplicacion` | `TEXT` | ¿Desde qué aplicación se realizó la operación? | Sí, porque no todas las conexiones proporcionan el nombre de la aplicación. |
| `ip_cliente` | `INET` | ¿Desde qué dirección IP se realizó la conexión? | Sí, porque algunas conexiones locales no tienen una dirección IP. |
| `operacion` | `TEXT` | ¿Qué tipo de acción se realizó, como INSERT, UPDATE o DELETE? | No, porque necesitamos conocer qué operación se registró. |
| `id_cliente` | `BIGINT` | ¿Qué cliente fue afectado por la operación? | Sí, porque no todos los eventos necesariamente afectan a un cliente específico. |
| `valores_antes` | `JSONB` | ¿Qué información tenía el registro antes del cambio? | Sí, porque en una inserción no existen valores anteriores. |
| `valores_despues` | `JSONB` | ¿Qué información tenía el registro después del cambio? | Sí, porque en una eliminación no existen valores posteriores. |

##Preguntas

### 1. ¿Por qué `momento` usa `TIMESTAMPTZ` y no `TIMESTAMP`?

Porque `TIMESTAMPTZ` permite almacenar la fecha y hora tomando en cuenta la zona horaria. Esto ayuda a tener un registro más confiable de cuándo ocurrió cada cambio, especialmente cuando existen conexiones desde diferentes ubicaciones o zonas horarias.

### 2. ¿Por qué se guarda el registro completo en `JSONB` y no solo la columna que cambió?

Porque guardar el registro completo permite conocer cómo estaban todos los datos antes y después de una modificación. Esto facilita revisar qué cambió, comparar la información y recuperar los valores anteriores si es necesario. Además, `JSONB` permite almacenar los datos de forma flexible.

### 3. La tabla de auditoría también contendrá RFC. ¿Qué implica eso para su clasificación y su control de acceso?

Significa que la tabla de auditoría también debe considerarse información sensible, porque contiene datos personales de los clientes, como el RFC. Por eso debe tener acceso restringido únicamente al DBA y al personal autorizado para realizar auditorías. También se deben proteger sus registros para evitar que alguien consulte, modifique o elimine información sin permiso.