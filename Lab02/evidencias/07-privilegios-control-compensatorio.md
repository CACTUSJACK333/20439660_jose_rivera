### Actividad 7 — Cambios de privilegios: el límite más importante

**1. ¿Por qué un cambio de privilegios es uno de los eventos auditables más importantes?**

Porque puede cambiar lo que un usuario tiene permitido hacer dentro de la base de datos. Si alguien recibe permisos adicionales sin autorización, podría consultar, modificar o eliminar información que antes no podía utilizar. Por eso es importante saber quién realizó estos cambios y cuándo ocurrieron.

**2. ¿Con qué frecuencia tomarías instantáneas? ¿Qué factores influyen?**

Tomaría instantáneas diariamente y también después de cada cambio importante de usuarios o privilegios. La frecuencia dependería del tamaño del sistema, la cantidad de cambios de permisos, el nivel de seguridad requerido y la importancia de la información almacenada.

**3. ¿Quién debería poder escribir en `auditoria.instantaneas_privilegios`?**

Solamente el personal autorizado de administración o auditoría debería tener permiso para escribir en esa colección. Los usuarios normales de la aplicación no deberían poder modificar ni eliminar esas evidencias, para evitar alteraciones en los registros.

**4. Redacta en tres líneas cómo comunicarías esta limitación a Dirección.**

MongoDB Community no registra directamente quién realiza los cambios de privilegios.  
Podemos guardar instantáneas para comparar los permisos de los usuarios antes y después de cada cambio.  
Sin embargo, necesitamos controles adicionales para tener una trazabilidad completa y evitar que estos cambios pasen desapercibidos.