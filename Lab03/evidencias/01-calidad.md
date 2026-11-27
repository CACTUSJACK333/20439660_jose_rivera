Actividad 1 — Calidad de datos desde la operación

| **#** | **Hallazgo** | **Registros** | **Regla de calidad** | **¿Quién decide la corrección?** | **Acción propuesta** |
|---|---|---|---|---|---|
| C1 | Posible cliente duplicado | 1 y 8 | Unicidad del correo | Responsable de los datos | Verificar si es el mismo cliente y corregir el duplicado. |
| C2 | RFC incompleto o incorrecto | 8 | Formato del RFC | Responsable de los datos | Confirmar el RFC correcto antes de modificarlo. |
| C3 | Correo inválido | 9 | Formato del correo | Responsable de los datos | Solicitar y verificar un correo válido. |
| C4 | Datos incorrectos o incompletos (edad negativa, RFC faltante y teléfono incompleto) | 9 | Validación de edad, RFC y teléfono | Responsable de los datos | Confirmar la información con el cliente y corregirla. |

#### Preguntas

**1. ¿Por qué el DBA no debe corregir por su cuenta el RFC del registro 8?**

Porque el DBA no conoce cuál es el RFC correcto del cliente. Debe solicitar autorización y confirmación al responsable de los datos para evitar modificar información personal incorrectamente.

**2. ¿Qué restricción (`CHECK`, `UNIQUE`) habría evitado cada hallazgo? ¿Quién debería aprobar agregarla?**

- C1: `UNIQUE` sobre el correo normalizado para evitar duplicados.
- C2: `CHECK` para validar el formato del RFC.
- C3: `CHECK` para validar el formato del correo.
- C4: `CHECK` para validar la edad y la longitud del teléfono, además de `NOT NULL` para el RFC.

Las restricciones deben ser aprobadas por el responsable o propietario de los datos, y el DBA se encarga de implementarlas.

**3. Si el DBA corrige un dato, ¿qué mecanismo del LAB-01 (Parte B) dejará evidencia del cambio?**

El trigger de auditoría que registra los cambios en `auditoria.cambios_clientes`, guardando el valor anterior, el nuevo, la fecha, el usuario y la operación realizada.