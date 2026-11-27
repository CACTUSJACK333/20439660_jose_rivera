# Actividad 5. Criterio de conservación de bitácoras

## 1. Tabla de conservación

| Registro | Ubicación actual | Riesgo de pérdida observado | Sensibilidad | Periodo propuesto | Justificación | Dónde se conserva | Quién puede leerlo | Acción al vencer |
|---|---|---|---|---|---|---|---|---|
| Accesos de PostgreSQL | Archivo del colector (`pg_current_logfile()`) | Rotación o eliminación del archivo | Alta | 90 días | Permite revisar accesos e intentos fallidos recientes | Almacenamiento seguro externo | DBA y auditor autorizado | Eliminar de forma segura |
| Cambios de privilegios y estructura | Archivo del colector | Rotación o pérdida del servidor | Alta | 1 año | Permite investigar cambios en usuarios, roles y estructura | Repositorio seguro de evidencias | DBA y responsable de seguridad | Eliminar después de revisar que no exista una investigación pendiente |
| Modificaciones de datos (`log_statement = 'mod'`) | Archivo del colector | Pérdida por rotación y exposición de datos sensibles | Alta | 1 año | Permite investigar modificaciones realizadas en la base | Almacenamiento seguro externo | DBA y auditor autorizado | Eliminar de forma segura |
| `auditoria.cambios_clientes` | Tabla en `comercial` | Eliminación accidental o pérdida de la base | Alta, contiene datos personales | 1 año | Permite conocer quién modificó información de los clientes | Base de datos y respaldo seguro | DBA y auditor autorizado | Eliminar o anonimizar según la política de datos |
| Bitácora de `mongod` | `systemLog.path` o salida estándar; `getLog` solo en memoria | Pérdida de registros al reiniciar o rotar el servidor | Alta | 90 días | Permite investigar accesos y eventos de seguridad | Archivos externos protegidos | Administrador MongoDB y auditor autorizado | Eliminar de forma segura |
| `system.profile` | Colección limitada de 1 MB | Los registros antiguos se sobrescriben automáticamente | Media-alta | 7 días | Sirve para analizar operaciones y rendimiento recientes | Colección y exportación temporal protegida | Administrador MongoDB y DBA | Eliminar registros vencidos |
| Instantáneas de privilegios (MongoDB) | `auditoria.instantaneas_privilegios` | Eliminación accidental o pérdida de la base | Alta | 1 año | Permite comparar usuarios, roles y permisos a través del tiempo | Base de datos y almacenamiento seguro externo | Administrador MongoDB y auditor autorizado | Eliminar después de verificar que no exista una revisión pendiente |

## 2. Preguntas

**1. ¿Por qué la bitácora de cambios de privilegios merece más tiempo de conservación que la de consultas rutinarias?**

Porque los cambios de privilegios pueden afectar la seguridad de toda la base de datos. Conservarlos durante más tiempo permite investigar accesos indebidos y conocer quién otorgó o retiró permisos. Las consultas rutinarias generalmente tienen menor importancia para una investigación de seguridad.

**2. ¿Qué control de integridad aplicarás a las bitácoras exportadas?**

Aplicaría una función hash SHA-256 para generar una huella digital de cada archivo exportado. Así se puede comprobar si el archivo fue modificado después de guardarse. También conservaría los archivos en una ubicación con acceso restringido.

**3. ¿Qué diferencia hay entre conservar una bitácora y respaldar una base de datos?**

Conservar una bitácora significa guardar registros de las actividades realizadas, como accesos, modificaciones y cambios de permisos. Respaldar una base de datos significa guardar una copia de su información para poder recuperarla si ocurre una falla o pérdida de datos.

## 3. Observaciones

Los periodos indicados son propuestas para la práctica y deben revisarse con los responsables de la organización. Si existe una obligación legal o una investigación pendiente, el plazo deberá confirmarse con el área jurídica.

También es importante proteger las bitácoras porque pueden contener información personal e incluso credenciales. Antes de compartirlas deben revisarse y ocultarse los datos sensibles.