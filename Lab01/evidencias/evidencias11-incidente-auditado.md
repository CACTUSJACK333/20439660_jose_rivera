### Actividad 12 — El incidente auditado

**1. Compara tu hipótesis de la Actividad 11 con este resultado.**

Mi hipótesis era que, si la función no tuviera `SECURITY DEFINER`, el usuario `app_ventas` no podría registrar los cambios en la tabla de auditoría, ya que no tiene permisos directos sobre ella. El resultado demuestra que `SECURITY DEFINER` permite que la función se ejecute con los permisos de su propietario, en este caso `postgres`, mientras que `session_user` conserva el nombre del usuario que inició la sesión. Así se puede guardar quién realizó realmente la operación sin darle acceso directo a la tabla de auditoría.

**2. Escribe la sentencia `UPDATE` que restauraría el valor anterior.**

Para restaurar el RFC anterior del cliente con id 3, utilizaría:

```sql
update clientes
set rfc = 'GAMA780912XYZ'
where id = 3;
```

**3. ¿Qué columna conserva más valor para una investigación: `aplicacion` o `ip_cliente`? ¿Cuál puede falsificar el cliente con más facilidad?**

Considero que `ip_cliente` conserva más valor para una investigación porque permite conocer desde qué dirección se realizó la conexión. Por otro lado, `aplicacion` también es útil para identificar desde qué programa se hizo la operación, pero el propio cliente puede modificar el valor de `application_name` y colocar el nombre que quiera. Por eso, esta última columna es más fácil de falsificar.