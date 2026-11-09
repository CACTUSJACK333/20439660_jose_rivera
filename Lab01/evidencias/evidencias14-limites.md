### Actividad 15 — Límites: lecturas y volumen

**1. Si `clientes` tuviera un millón de registros, ¿qué ocurriría con la auditoría tras un `UPDATE` sin `WHERE`?**

Se generarían aproximadamente un millón de registros en la tabla de auditoría, uno por cada fila modificada. Esto podría ocupar mucho espacio de almacenamiento y aumentar el trabajo del servidor. Por eso es importante tener cuidado con las modificaciones masivas y revisar cuántos registros se van a afectar antes de ejecutar una consulta.

**2. Propón quién podría autorizar la depuración de `auditoria.cambios_clientes`.**

La depuración debería ser autorizada por el responsable de seguridad o auditoría, junto con el DBA. El DBA podría encargarse de realizarla, pero no debería decidir por sí solo qué registros eliminar. También tendría que existir una política que indique cuánto tiempo se conservarán los registros y cuáles pueden eliminarse.

**3. ¿Por qué `log_statement = 'all'` puede convertir la bitácora en un nuevo depósito de datos sensibles?**

Porque registra todas las consultas que se ejecutan en la base de datos, incluyendo aquellas que muestran información personal como RFC, teléfonos, correos y otros datos de los clientes. Esto provoca que la bitácora también almacene información sensible, por lo que necesita protección, control de acceso y una política de conservación.