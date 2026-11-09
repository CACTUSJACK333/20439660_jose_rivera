### Actividad 13 — Altas y bajas

**1. El cliente Pedro Ruiz ya no existe en clientes. ¿Dónde queda evidencia de que existió y de sus datos?**

La evidencia queda guardada en la tabla `auditoria.cambios_clientes`. Aunque el registro fue eliminado de la tabla `clientes`, el disparador guardó la información de la operación DELETE, incluyendo los datos que tenía el cliente antes de ser eliminado.

**2. ¿Por qué ip_cliente está vacía en los eventos 2 y 3?**

Porque las operaciones se realizaron desde una sesión local con el usuario `postgres`, utilizando psql, y no desde una conexión TCP/IP. Por eso PostgreSQL no registra una dirección IP para esas conexiones.

**3. La política de retención de la Unidad II pedía eliminar datos cuando ya no fueran necesarios. ¿Qué conflicto aparece? ¿Quién debe resolverlo?**

El conflicto es que, aunque se deben eliminar los datos personales cuando ya no sean necesarios, la auditoría conserva información del cliente como evidencia de las operaciones realizadas. Esto significa que también se debe controlar cuánto tiempo se guarda esa información. La decisión debe tomarla la organización, junto con el área responsable de protección de datos, el DBA y el área de auditoría, estableciendo una política de retención para esos registros.