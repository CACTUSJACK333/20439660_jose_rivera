# Informe

## 1. Despliegue, edición y limitación

Para realizar este laboratorio instalé MongoDB Community 9.0.8 en Windows 10 y utilicé `mongosh` 2.14.2 para ejecutar los comandos y administrar las bases de datos.

El servidor quedó configurado para utilizar el puerto 27017, escuchar únicamente en la dirección local `127.0.0.1` y trabajar con autenticación habilitada. También se configuró el registro de eventos en un archivo físico mediante `systemLog.destination: file`.

Durante la primera actividad revisé la versión del servidor, su configuración y los módulos disponibles. El resultado de `db.adminCommand({ buildInfo: 1 }).modules` fue un arreglo vacío (`[]`), lo que corresponde a la edición Community que utilicé.

Una de las limitaciones encontradas es que MongoDB Community no cuenta con la auditoría nativa disponible en las ediciones Enterprise. Por esta razón, fue necesario utilizar el perfilador, la bitácora del servidor y algunas medidas adicionales para obtener evidencia de las operaciones.

## 2. Perfilador

El perfilador de MongoDB permite registrar información sobre las operaciones realizadas en una base de datos. Al inicio del laboratorio se encontraba desactivado, por lo que el primer cambio de RFC no quedó registrado en `system.profile`.

Después activé el perfilador con el nivel 2:

`db.setProfilingLevel(2);`

Con este nivel se registraron operaciones como consultas, actualizaciones y eliminaciones. En los resultados fue posible identificar el usuario `app_ventas@comercial`, la aplicación declarada `app-ventas-web`, la dirección del cliente y el momento de ejecución.

Posteriormente configuré el nivel 1 con un filtro para registrar únicamente operaciones de inserción, actualización y eliminación:

`db.setProfilingLevel(1, { filter: { op: { $in: ["insert", "update", "remove"] } } });`

Esta configuración permitió reducir la cantidad de operaciones registradas y concentrarse en los cambios realizados sobre los datos.

El perfilador tiene un costo que debe considerarse, ya que registrar todas las operaciones puede generar mayor uso de almacenamiento y afectar el rendimiento. También puede guardar información sensible, como filtros de consultas y valores enviados en las actualizaciones.

Por eso, aunque aporta información útil para investigar operaciones, no debe utilizarse como sustituto de una auditoría de seguridad.

## 3. Bitácora de mongod

Durante la práctica revisé la configuración de la bitácora del servidor. El archivo físico se encontraba en:

`C:\Program Files\MongoDB\Server\9.0\log\mongod.log`

La bitácora permitió identificar eventos relacionados con conexiones, autenticaciones y cambios en la configuración del perfilador.

En la Actividad 5 realicé dos intentos fallidos de acceso: uno utilizando una contraseña incorrecta para `app_ventas` y otro utilizando un usuario inexistente. Ambos intentos quedaron registrados, aunque con errores diferentes.

También fue posible identificar una autenticación exitosa de `app_ventas` y relacionarla con su conexión correspondiente.

En la Actividad 6 revisé los eventos relacionados con los cambios de configuración del perfilador. Al comparar el identificador de conexión con el evento de autenticación, pude relacionar los cambios con una sesión administrativa.

Esto demuestra que la bitácora es útil para investigar lo que sucede en el servidor, aunque no registra automáticamente todos los detalles de las operaciones realizadas sobre los documentos.

## 4. Privilegios

Una de las limitaciones más importantes encontradas fue la falta de evidencia directa de los cambios de privilegios en MongoDB Community.

Durante la Actividad 7 agregué temporalmente el rol `dbAdmin` al usuario `app_ventas`, que inicialmente tenía el rol `readWrite` en la base de datos `comercial`.

Al buscar el comando `grantRolesToUser` en `system.profile` y en la bitácora consultada mediante `getLog`, no encontré registros que permitieran identificar directamente ese cambio.

Para tener una forma de seguimiento utilicé un control compensatorio basado en instantáneas. Guardé los roles de los usuarios en la colección `auditoria.instantaneas_privilegios` antes y después de agregar el nuevo privilegio.

Al comparar las dos instantáneas pude observar que `app_ventas` pasó de tener únicamente `readWrite` a tener también `dbAdmin`.

Después ejecuté el comando para revocar el rol temporal. Sin embargo, este método tiene una limitación: permite comparar los estados de los privilegios, pero no sustituye una auditoría automática ni garantiza por sí solo quién realizó cada cambio.

## 5. Conservación

Durante la Actividad 8 comprobé que la información del perfilador y la bitácora puede perderse si no se conserva mediante exportaciones.

Antes de reiniciar MongoDB exporté los siguientes archivos:

- `system-profile.json`
- `bitacora-mongod.log`
- `hashes.sha256`

También realicé una copia adicional del archivo físico de la bitácora llamada `mongod-completo.log`.

Generé hashes SHA-256 para comprobar la integridad de las tres exportaciones registradas en `hashes.sha256`.

Antes del reinicio obtuve estos resultados:

- Nivel del perfilador: 1.
- Documentos en `system.profile`: 4.
- Eventos en `getLog`: 1023.

Después de reiniciar el servicio MongoDB, los resultados fueron:

- Nivel del perfilador: 0.
- Documentos en `system.profile`: 4.
- Eventos en `getLog`: 137.

Con esta comparación comprobé que el nivel del perfilador volvió a cero, mientras que los cuatro registros de `system.profile` permanecieron. También observé que `getLog` comenzó a mostrar los eventos generados después del reinicio, porque su contenido se conserva temporalmente en memoria.

Esta actividad permitió comprobar la importancia de exportar las evidencias antes de reiniciar el servidor y no depender únicamente de los registros que permanecen disponibles en memoria.

## 6. Comparación

Al comparar PostgreSQL, MongoDB Community y MongoDB Enterprise/Atlas, encontré diferencias importantes en la forma de obtener evidencia.

En PostgreSQL, durante el LAB-01, utilicé la bitácora del servidor y un disparador para registrar modificaciones en los datos. El disparador permitió conservar tanto el valor anterior como el nuevo, lo que facilitó investigar los cambios realizados.

En MongoDB Community utilicé el perfilador y la bitácora de `mongod`. Estas herramientas permitieron identificar operaciones, usuarios, conexiones y algunos cambios de configuración. Sin embargo, no fue posible obtener directamente todos los cambios de privilegios ni conservar automáticamente los valores anteriores de los documentos.

Por otro lado, MongoDB Enterprise y Atlas cuentan con funciones de auditoría nativa que ofrecen una cobertura más amplia de eventos de seguridad. Estas capacidades se consultaron como parte de la documentación, pero no se probaron directamente durante el laboratorio.

La principal diferencia es que PostgreSQL permitió obtener mayor detalle sobre los cambios en los documentos gracias al disparador, mientras que MongoDB Community requirió controles adicionales para compensar algunas de sus limitaciones.

## 7. Recomendación

Para una organización que necesita auditar los cambios de privilegios en MongoDB, recomendaría utilizar una edición o servicio que cuente con auditoría nativa, como MongoDB Enterprise o Atlas, siempre que se compruebe que los eventos necesarios están disponibles y se configure correctamente el registro.

Esto permitiría tener una mejor evidencia de los eventos de seguridad y facilitaría las investigaciones cuando se realicen cambios en los permisos de los usuarios.

Si la organización debe continuar utilizando MongoDB Community, recomendaría mantener instantáneas periódicas de los privilegios, restringir quién puede administrar los roles y conservar las evidencias en archivos externos con hashes de integridad. También sería conveniente registrar los cambios mediante un procedimiento administrativo controlado.

**Hechos verificados durante el laboratorio:**
- MongoDB Community 9.0.8 no proporcionó evidencia directa del cambio de privilegios que realizamos.
- Las consultas al perfilador y a `getLog` no mostraron el comando `grantRolesToUser`.
- Las instantáneas permitieron observar la diferencia entre los privilegios anteriores y posteriores al cambio.
- El reinicio del servidor afectó el perfilador y la memoria de `getLog`.

**Aspectos que no se probaron directamente:**
- La auditoría nativa de MongoDB Enterprise o Atlas.
- La cobertura exacta de todos los eventos de cambios de privilegios en esas ediciones.
- El comportamiento de una solución de auditoría externa en un entorno de producción.

Por lo tanto, la recomendación se basa en las limitaciones que comprobé durante la práctica y en las capacidades descritas en la documentación, sin asumir que todas las funciones de otras ediciones fueron probadas.

---

# 20. Preguntas de reflexión

### 1. ¿Por qué el perfilador no debe presentarse como un mecanismo de auditoría de seguridad?

Porque su objetivo principal es registrar información sobre las operaciones para analizar su comportamiento y rendimiento. Aunque permite identificar usuarios, consultas y modificaciones, no registra todos los eventos de seguridad ni garantiza una evidencia completa de quién realizó cada cambio. Por eso no debe considerarse una auditoría de seguridad completa.

### 2. ¿Por qué el perfilador sí aporta trazabilidad aunque no sea auditoría?

Porque permite conocer qué operaciones se ejecutaron, cuándo ocurrieron, qué usuario las realizó y desde qué aplicación o cliente se enviaron. Esta información ayuda a reconstruir parte de lo que sucedió en la base de datos, aunque no siempre permite conocer todos los detalles de una operación.

### 3. ¿Qué riesgo introduce el nivel 2 al registrar filtros de consultas que pueden contener datos personales?

El nivel 2 registra todas las operaciones, por lo que puede guardar filtros de búsqueda y valores que contengan información personal o sensible. Esto aumenta el riesgo de exposición de datos y también genera más información que debe almacenarse y protegerse. Por eso es importante controlar quién puede consultar los registros y evitar utilizar este nivel de forma permanente sin una justificación.

### 4. ¿Qué diferencia hay entre detectar un cambio y atribuirlo a alguien?

Detectar un cambio significa tener evidencia de que un dato o permiso fue modificado. Atribuirlo a alguien significa poder relacionar ese cambio con una identidad o sesión específica y tener evidencia suficiente para sostener que esa persona o cuenta realizó la acción. No es lo mismo saber que algo cambió que demostrar quién lo hizo.

### 5. ¿Por qué reconocer una limitación técnica es parte del trabajo profesional del DBA?

Porque un DBA debe conocer las herramientas que administra y saber qué información pueden registrar y cuál no. Si se presenta una evidencia incompleta como si fuera una auditoría total, se pueden tomar decisiones equivocadas. Reconocer las limitaciones permite buscar controles adicionales, proteger mejor la información y comunicar con claridad los riesgos a la organización.