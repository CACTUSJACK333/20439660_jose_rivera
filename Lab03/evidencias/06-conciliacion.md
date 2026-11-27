# Actividad 7. Registro de cambios y conciliación

## 1. Tabla de conciliación

| Cambio detectado | Usuario | Fecha | Folio relacionado | Resultado |
|---|---|---|---|---|
| ALTER TABLE clientes ADD COLUMN canal_alta VARCHAR(20) | postgres | 25/11/2026 22:02:59 | CAM-2026-014 | Autorizado y registrado |
| COMMENT ON COLUMN clientes.canal_alta | postgres | 25/11/2026 | CAM-2026-014 | Registrado |
| REVOKE UPDATE ON clientes FROM soporte_ana | postgres | 02/11/2026 13:24:55 | No identificado | Requiere revisión |
| GRANT UPDATE ON clientes TO app_ventas | postgres | 02/11/2026 | No identificado | Requiere revisión |
| ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes | app_ventas | 02/11/2026 14:21:04 | No identificado | Cambio de riesgo alto |
| ALTER TABLE clientes DISABLE TRIGGER trg_auditoria_clientes | postgres | 02/11/2026 14:21:23 | No identificado | Requiere investigación |

## 2. Preguntas

**1. ¿Qué cambios de la bitácora no tienen folio y cómo se clasifican?**

Los cambios GRANT UPDATE, REVOKE UPDATE y DISABLE TRIGGER no tienen un folio identificado. Se clasifican como cambios pendientes de conciliación. La desactivación del disparador representa un riesgo alto porque puede impedir el registro de modificaciones realizadas a los clientes.

**2. ¿Por qué desactivar un trigger de auditoría es un cambio de mayor gravedad que modificar una columna?**

Porque al desactivar el trigger se puede perder el registro de los cambios realizados a los datos. En cambio, agregar una columna modifica la estructura de la tabla, pero no necesariamente afecta el mecanismo de auditoría.

**3. ¿Qué limitación tendría esta conciliación si log_statement estuviera en none?**

No se registrarían las instrucciones SQL ejecutadas mediante log_statement. Esto dificultaría identificar cambios en la estructura, permisos y datos, haciendo más complicada la investigación de incidentes.

**4. ¿Quién debe realizar la conciliación y qué debe hacer cuando encuentra un cambio sin folio?**

El DBA debe comparar las solicitudes autorizadas con las operaciones registradas en las bitácoras. Cuando encuentra un cambio sin folio, debe documentarlo, investigar quién lo realizó y solicitar la aclaración o autorización correspondiente al responsable de TI.
