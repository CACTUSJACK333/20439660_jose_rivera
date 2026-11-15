# 09. Comparación de los tres escenarios

| Evento auditable | PostgreSQL (bitácora + disparador) | MongoDB Community (perfilador + bitácora) | MongoDB Enterprise/Atlas (auditoría nativa) |
|---|---|---|---|
| Acceso exitoso | Parcial: se pueden registrar conexiones, pero no se tiene evidencia completa de todas las sesiones. | Sí (observado): la bitácora mostró una autenticación exitosa de `app_ventas`. | Documentado, no practicado. |
| Acceso fallido | Sí (observado): la bitácora registró errores de autenticación. | Sí (observado): registramos intentos con contraseña incorrecta y usuario inexistente. | Documentado, no practicado. |
| Cambio de privilegios | Sí (observado): se registraron sentencias `GRANT` y `REVOKE` en la bitácora. | No: el cambio de roles no apareció directamente en el perfilador ni en la bitácora. Se utilizó una comparación de instantáneas como control compensatorio. | Documentado, no practicado. |
| Cambio de estructura | Sí (observado): la bitácora permite registrar sentencias de definición y modificación de objetos. | No: con la configuración utilizada no obtuvimos evidencia de cambios de estructura. | Documentado, no practicado. |
| Modificación de datos | Sí (observado): el disparador registró modificaciones, inserciones y eliminaciones. | Sí (observado): el perfilador registró operaciones `update` y `remove`. | Documentado, no practicado. |
| Valor anterior del dato | Sí (observado): el disparador guardó los valores anteriores y nuevos del registro. | No: el perfilador mostró el valor nuevo enviado en la operación, pero no el valor anterior. | No: la auditoría nativa no garantiza por sí sola conservar el valor anterior del documento. |
| Lectura de datos sensibles | No: en la práctica no se obtuvo evidencia de esas lecturas; `log_statement=mod` no registra consultas `SELECT`. | Parcial: el perfilador registró consultas `find`, pero no los documentos devueltos y el filtro posterior dejó fuera las lecturas. | Documentado, no practicado. |
| Cambio de configuración del registro | Sí (observado): se registró el cambio de `log_statement` mediante `ALTER SYSTEM`. | Sí (observado): la bitácora mostró cambios en la configuración del perfilador y fue posible relacionarlos con una sesión administrativa. | Parcial: depende del evento y comando; no se comprobó en la práctica que todos los cambios de configuración del propio registro queden auditados. |

