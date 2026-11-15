# 10. Respuesta a Dirección

### 1. ¿Quién cambió el RFC de María García en la Actividad 2? ¿Y en la Actividad 3?

En la Actividad 2 no hay evidencia con esta edición para identificar directamente quién realizó el cambio, porque el perfilador estaba desactivado y la bitácora no registró la operación de modificación.

En la Actividad 3 sí se pudo identificar al usuario `app_ventas@comercial`, gracias a que el perfilador estaba activado y registró la operación de actualización.

### 2. ¿Cuándo y desde qué aplicación?

En la Actividad 2 no fue posible determinar el momento exacto ni relacionar una aplicación con la modificación del RFC, porque no quedó registrada la operación.

En la Actividad 3, el cambio quedó registrado el **15 de noviembre de 2026 a las 17:46:10 UTC** (10:46:10, hora local). La aplicación identificada fue `app-ventas-web`, desde el cliente `127.0.0.1`.

### 3. ¿Qué valor tenía antes?

El documento se creó originalmente con el RFC `GAMA780912GHI`. En la Actividad 2 se modificó a `GAMA780912XXX` y en la Actividad 3 se cambió a `GAMA780912XYZ`.

Sin embargo, el perfilador solamente registró el nuevo valor enviado en la actualización, no guardó automáticamente el valor anterior. Por eso no funciona como un historial completo de los cambios del documento.

### 4. ¿Cambió alguien los privilegios de `app_ventas` recientemente?

Sí. Durante la Actividad 7 se agregó temporalmente el rol `dbAdmin` al usuario `app_ventas`, que originalmente tenía únicamente `readWrite` en la base `comercial`.

Después se revocó el rol `dbAdmin` y se verificó que el usuario conservara solamente `readWrite`. Las instantáneas de privilegios permitieron observar la diferencia entre ambos estados.

No obstante, este control compensatorio no equivale a una auditoría nativa, porque no registra automáticamente todos los cambios ni garantiza por sí solo quién los realizó.
