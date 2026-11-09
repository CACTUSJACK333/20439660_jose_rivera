# Actividad 7 — Preguntas de análisis

### 1. ¿Qué nivel habría registrado la lectura del RFC? ¿Qué costo tendría en un servidor con miles de consultas por minuto?

Para registrar la lectura del RFC se tendría que utilizar `log_statement = 'all'`, ya que esta configuración registra todas las consultas SQL, incluyendo los `SELECT`. El problema es que en un servidor con miles de consultas por minuto se generarían demasiados registros, lo que ocuparía espacio en el disco y podría afectar el rendimiento del servidor.

### 2. ¿Qué le falta a esta bitácora para revertir el cambio con certeza?

Le falta registrar los valores anteriores y nuevos de los datos modificados. La bitácora actual permite saber qué sentencia se ejecutó, pero no necesariamente conserva toda la información necesaria para recuperar el estado anterior del registro. Para poder revertir el cambio con certeza se necesitaría una auditoría que guarde los valores anteriores y posteriores, además de información como el usuario y la fecha en que ocurrió la modificación.