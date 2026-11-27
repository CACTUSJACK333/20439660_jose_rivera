# Actividad 3. Diccionario de datos operativo

## 1. Diccionario técnico

| Columna | Tipo de dato | Permite nulos | Valor por defecto | Descripción |
|---|---|---|---|---|
| id | bigint | No | nextval(...) | Identificador interno del cliente. |
| nombre | varchar(120) | No | — | Nombre completo del cliente. |
| correo | varchar(150) | No | — | Correo de contacto para notificaciones. |
| telefono | varchar(20) | Sí | — | Teléfono de contacto del cliente. |
| rfc | varchar(13) | Sí | — | RFC utilizado para facturación. |
| edad | integer | Sí | — | Edad del cliente en años cumplidos. |
| ciudad | varchar(80) | Sí | — | Ciudad de residencia del cliente. |
| codigo_postal | varchar(10) | Sí | — | Código postal del domicilio. |
| fecha_alta | date | Sí | CURRENT_DATE | Fecha de registro del cliente. |
| segmento | varchar(20) | Sí | — | Categoría comercial asignada al cliente. |

## 2. Diccionario de negocio

| Columna | Clasificación (Unidad II) | Finalidad | Control aplicado | ¿Cambios auditados? | Regla de calidad |
|---|---|---|---|---|---|
| id | Identificador interno | Identificar al cliente | Generación automática | Sí, mediante auditoría de cambios | No debe repetirse ni ser nulo. |
| nombre | Dato personal | Identificar al cliente | Acceso restringido | Sí, mediante auditoría de cambios | No debe estar vacío. |
| correo | Dato personal | Enviar notificaciones | Acceso restringido | Sí, mediante auditoría de cambios | Debe tener formato de correo válido y no repetirse. |
| telefono | Dato personal | Contactar al cliente | Acceso restringido | Sí, mediante auditoría de cambios | Debe contener un número telefónico válido. |
| rfc | Dato personal | Facturación | Acceso restringido y auditoría | Sí, mediante auditoría de cambios | Debe cumplir con el formato de RFC. |
| edad | Dato personal | Análisis estadístico | Uso para análisis agregado | Sí, mediante auditoría de cambios | Debe ser un valor positivo y razonable. |
| ciudad | Dato personal | Información comercial | Acceso restringido | Sí, mediante auditoría de cambios | Debe contener una ciudad válida. |
| codigo_postal | Dato personal | Ubicación geográfica | Acceso restringido | Sí, mediante auditoría de cambios | Debe cumplir con el formato postal correspondiente. |
| fecha_alta | Dato operativo | Registrar cuándo se dio de alta el cliente | Fecha generada por el sistema | Sí, mediante auditoría de cambios | No debe ser una fecha futura. |
| segmento | Dato de clasificación comercial | Clasificar clientes | Acceso según funciones | Sí, mediante auditoría de cambios | Debe pertenecer a una categoría permitida. |

*Nota: La auditoría de cambios depende de que el mecanismo de auditoría esté activo. Los controles indicados representan las medidas propuestas para cada dato.*

## 3. Preguntas

**1. ¿Qué ventaja tiene guardar el significado en COMMENT en lugar de solo en un documento aparte?**

Permite consultar la descripción directamente desde PostgreSQL, junto con la estructura de la tabla. Así, cualquier persona que revise la base de datos puede entender para qué sirve cada columna sin depender de otro documento.

**2. ¿Quedaron registrados los COMMENT en la bitácora? ¿Con qué nivel de log_statement?**

Sí, los comandos COMMENT quedan registrados como instrucciones de modificación de estructura. En este caso se utiliza `log_statement = 'mod'`, que registra este tipo de comandos.

**3. ¿Qué información del diccionario debe mantenerse fuera del motor? ¿Por qué?**

La información sobre responsables, propietarios del dato, políticas de conservación, autorizaciones y procedimientos de corrección debe mantenerse también en documentos externos, porque requiere acuerdos y actualizaciones organizacionales que no dependen únicamente de PostgreSQL.