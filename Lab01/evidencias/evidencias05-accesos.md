## 11.1 Leer una línea campo por campo

| **Campo** | **Valor** | **Significado** |
|---|---|---|
| Fecha y hora | `2026-10-25 22:50:00.334 UTC` | Indica el momento exacto en que ocurrió el intento de conexión. |
| PID | `91` | Es el identificador del proceso de PostgreSQL que atendió la conexión. |
| Usuario | `app_ventas` | Es el usuario con el que se intentó iniciar sesión. |
| Base de datos | `comercial` | Es la base de datos a la que se intentó acceder. |
| Aplicación | `[unknown]` | Indica que PostgreSQL no recibió el nombre de la aplicación. |
| Cliente | `127.0.0.1` | Es la dirección IP desde donde se realizó el intento de conexión. |
| Severidad | `FATAL` | Indica que ocurrió un error grave que impidió completar la conexión. |
| Mensaje | `password authentication failed` | Significa que la contraseña proporcionada no fue válida. |
| Regla aplicada | `pg_hba.conf` línea 119 | Indica la regla de autenticación que PostgreSQL utilizó para evaluar la conexión. |

### Preguntas

**1. La bitácora registra el usuario `app_ventas` en el intento fallido. ¿Eso prueba que la aplicación de ventas intentó entrar? ¿Qué prueba realmente?**

No necesariamente. Lo que demuestra es que alguien intentó conectarse utilizando el usuario `app_ventas` desde la dirección IP registrada. No podemos asegurar que haya sido la aplicación de ventas, ya que también pudo ser una persona u otro programa utilizando esas credenciales.

**2. ¿Qué información adicional registra PostgreSQL cuando el rol no existe? ¿Por qué aparece en la bitácora y no en el mensaje que recibe el cliente?**

Cuando el rol no existe, PostgreSQL puede registrar información adicional indicando que el rol no está definido en el servidor. Esta información sirve para que el administrador pueda investigar los intentos de acceso. Al cliente se le muestra un mensaje más general por seguridad, para evitar revelar detalles internos sobre los usuarios registrados en la base de datos.

**3. ¿Por qué `app=[unknown]` en el intento fallido, pero `app=app-ventas-web` en la desconexión?**

Porque en el intento fallido no se proporcionó el nombre de la aplicación al establecer la conexión. En cambio, en la conexión exitosa se utilizó el parámetro `application_name=app-ventas-web`, por lo que PostgreSQL pudo identificar de dónde provenía la conexión.

**4. ¿Qué patrón de varias líneas te haría sospechar de un ataque de fuerza bruta? Escribe la consulta que contaría los intentos fallidos por usuario.**

Un patrón sospechoso sería encontrar muchos intentos de inicio de sesión fallidos en poco tiempo, especialmente si se repiten desde la misma dirección IP y se prueban diferentes usuarios o contraseñas. Esto podría indicar que alguien está intentando adivinar las credenciales para entrar al sistema.

select
    substring(linea from 'user=([^ ]+)') as usuario,
    count(*) as intentos_fallidos
from dba.bitacora
where linea ilike '%password authentication failed%'
group by usuario
order by intentos_fallidos desc;