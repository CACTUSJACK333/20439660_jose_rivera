## 5. Preguntas de la actividad

### 1. ¿Puedes demostrar qué cambió? ¿Y quién se conectó a esa hora?

No porque el perfilador estaba desactivado y la búsqueda del RFC nuevo en la bitácora devolvió cero resultados.

Sin embargo, sí puedo identificar que hubo conexiones relacionadas con la aplicación `app-ventas-web`. En los eventos de la bitácora aparecen registros `ACCESS` con el mensaje `Successfully authenticated`, lo que demuestra que algunas conexiones se autenticaron correctamente. Esto no demuestra por sí solo quién realizó la actualización ni qué documento modificó.

### 2. ¿Por qué `mongosh` abre varias conexiones (`conn8`, `conn9`, …) para una sola instrucción? ¿Cuál es la que se autentica?

`mongosh` puede abrir varias conexiones porque utiliza diferentes conexiones internas para comunicarse con el servidor y realizar distintas tareas. Por eso, una sola sesión de terminal puede generar varios identificadores de conexión.

En los resultados aparecen conexiones como `conn8`, `conn9`, `conn10` y `conn11`. Las que muestran el mensaje `Successfully authenticated` son las que completaron correctamente la autenticación. Por ejemplo, en los resultados obtenidos aparecen `conn8`, `conn9`, `conn10` y `conn11` con ese mensaje.

No todas las conexiones realizan necesariamente operaciones de la aplicación; algunas pueden utilizarse para establecer comunicación o consultar información del servidor.