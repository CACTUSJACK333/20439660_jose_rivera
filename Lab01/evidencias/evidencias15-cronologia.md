# Actividad 17 — Reconstruir la cronología y responder a Dirección

## 1. Cronología de eventos

| # | Fecha y hora | Usuario | Cliente | Tipo de evento | Qué ocurrió | ¿Exitoso? | Fuente (línea o `id_evento`) |
|---|---|---|---|---|---|---|---|
| 1 | 2026-11-02 12:58:41 | app_ventas | No aplica | Acceso | Falló la autenticación por contraseña incorrecta. | No | Línea 33 |
| 2 | 2026-11-02 12:58:54 | usuario_inexistente | No aplica | Acceso | Intentó conectarse con un rol que no existe. | No | Líneas 36-37 |
| 3 | 2026-11-02 13:24:55 | postgres | No aplica | Privilegio | Revocó UPDATE a soporte_ana y concedió UPDATE a app_ventas. | Sí | Líneas 95-97 |
| 4 | 2026-11-02 13:24:55 | postgres | No aplica | Estructura | Agregó la columna segmento a la tabla clientes. | Sí | Línea 99 |
| 5 | 2026-11-02 13:25:09 | postgres | No aplica | Privilegio | Creó el rol temporal rol_temporal. | Sí | Línea 100 |
| 6 | 2026-11-02 13:25:12 | postgres | No aplica | Privilegio | Eliminó el rol temporal rol_temporal. | Sí | Línea 101 |
| 7 | 2026-11-02 13:34:09 | postgres | No aplica | Configuración | Cambió log_statement a mod. | Sí | Línea 123 |
| 8 | 2026-11-02 13:35:03 | app_ventas | 3 | Datos | Ejecutó una actualización del teléfono del cliente 3. | Sí, en el último intento registrado | Línea 127 |
| 9 | 2026-11-02 13:39:35 | soporte_ana | 5 | Error | Intentó eliminar al cliente 5, pero PostgreSQL rechazó la operación por falta de permisos. | No | Líneas 155-157 |
| 10 | 2026-11-02 13:39:54 | postgres | No aplica | Error | Intentó eliminar soporte_ana, pero había privilegios dependientes de ese rol. | No | Líneas 159-162 |
| 11 | 2026-11-02 13:59:06 | app_ventas | 3 | Datos | Cambió el RFC de GAMA780912XYZ a GAMA780912ZZZ. | Sí | Línea 265 e id_evento 1 |
| 12 | 2026-11-02 14:19:38 | postgres | 6 | Datos | Insertó un registro de prueba para Pedro Ruiz. | Sí | id_evento 2 |
| 13 | 2026-11-02 14:19:38 | postgres | 6 | Datos | Eliminó el registro de Pedro Ruiz. | Sí | id_evento 3 |
| 14 | 2026-11-02 14:21:04 | app_ventas | 3 | Error | Intentó desactivar el trigger de auditoría, pero no era propietario de la tabla. | No | Líneas 316-318 |
| 15 | 2026-11-02 14:21:23 | postgres | 3 | Datos | Desactivó el trigger de auditoría. | Sí | Línea 320 |
| 16 | 2026-11-02 14:21:25 | postgres | 3 | Datos | Cambió el RFC a GAMA780912GHI mientras el trigger estaba desactivado. | Sí, pero no quedó en la tabla de auditoría | Línea 321 |
| 17 | 2026-11-02 14:21:29 | postgres | 3 | Datos | Volvió a activar el trigger de auditoría. | Sí | Línea 322 |
| 18 | 2026-11-02 14:23:26 | postgres | 1 al 5 | Datos | Ejecutó una actualización masiva para asignar el segmento regular a los clientes. | Sí | Línea 337 e id_eventos 11-15 |

## 2. Respuestas a las preguntas de Dirección

### 1. ¿Quién hizo el cambio del RFC?

- **Actividad 3:** No hay evidencia. El cambio ocurrió antes de contar con una bitácora que registrara la sentencia, por lo que no se puede identificar al usuario.
- **Actividad 7:** La actividad utilizó la cuenta `app_ventas` para ejecutar el cambio a `GAMA780912XYZ`. Sin embargo, la sentencia no quedó registrada porque `log_statement` todavía estaba configurado en `ddl`. La auditoría posterior confirma que ese era el RFC anterior al cambio de la Actividad 12.
- **Actividad 12:** Lo hizo `app_ventas`, mediante la aplicación `app-ventas-web`.
- **Actividad 14:** Lo hizo `postgres`, desde pgAdmin, después de desactivar el trigger de auditoría.

### 2. ¿Cuándo se realizaron los cambios?

- **Actividad 3:** No hay evidencia de la hora exacta.
- **Actividad 7:** No hay evidencia de la hora exacta del UPDATE, porque la sentencia no quedó registrada.
- **Actividad 12:** 2 de noviembre de 2026 a las 13:59:06.
- **Actividad 14:** 2 de noviembre de 2026 a las 14:21:25.

### 3. ¿Desde qué aplicación o equipo se realizaron?

- **Actividad 3:** No hay evidencia.
- **Actividad 7:** Se utilizó la cuenta `app_ventas` y el ejercicio indicaba la aplicación `app-ventas-web`, pero no hay una línea que confirme la ejecución exacta de ese UPDATE.
- **Actividad 12:** Desde `app-ventas-web`, con dirección IP `127.0.0.1`.
- **Actividad 14:** Desde pgAdmin 4, con dirección `::1`, utilizando el usuario administrador `postgres`.

Las direcciones `127.0.0.1` y `::1` corresponden a conexiones locales del mismo equipo.

### 4. ¿Hubo intentos de acceso fallidos? ¿De qué usuarios y desde dónde?

Sí. La bitácora muestra los siguientes intentos fallidos:

- `app_ventas`: 12:58:41, 12:59:06 y 13:28:36, desde `127.0.0.1`, por contraseña incorrecta.
- `usuario_inexistente`: 12:58:54, desde `127.0.0.1`, porque el rol no existía.
- `soporte_ana`: 13:39:13, desde `127.0.0.1`, por contraseña incorrecta.

Todos fueron intentos de conexión local. La bitácora demuestra que ocurrieron, pero no permite afirmar quién estaba utilizando físicamente el equipo.

### 5. ¿Qué valor tenía el RFC antes de cada cambio?

- **Actividad 3:** No hay evidencia del valor anterior porque el cambio ocurrió antes de contar con registros suficientes.
- **Actividad 7:** No hay evidencia del valor anterior exacto. La tabla de auditoría confirma que, después de esta actividad, el RFC era `GAMA780912XYZ`.
- **Actividad 12:** El valor anterior era `GAMA780912XYZ` y el nuevo fue `GAMA780912ZZZ`, como muestra el `id_evento` 1.
- **Actividad 14:** El valor anterior era `GAMA780912ZZZ` y el nuevo fue `GAMA780912GHI`. La sentencia aparece en la bitácora, pero no en la tabla de auditoría porque el trigger estaba desactivado.

## 3. Conclusión

Con esta actividad pude comprobar que las bitácoras y la tabla de auditoría permiten conocer mejor lo que sucede en una base de datos. En el caso del RFC, fue posible identificar al usuario, la hora, la aplicación y el valor anterior en el cambio de la Actividad 12.

También se comprobó que un administrador puede desactivar el trigger y realizar cambios que no quedan registrados en la tabla de auditoría. Sin embargo, la bitácora del servidor sí conservó evidencia de esas operaciones.

Por último, el primer cambio del incidente no se puede reconstruir porque no existía un registro adecuado en ese momento. Esto demuestra la importancia de configurar la auditoría antes de que ocurra un problema.