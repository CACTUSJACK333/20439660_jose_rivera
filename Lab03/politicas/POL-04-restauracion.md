# POL-04 — Política de restauración

**Objetivo:** Recuperar la información cuando ocurra una falla o pérdida de datos.

**Alcance:** Aplica a PostgreSQL, MongoDB y sus respectivos respaldos.

**Regla:** Toda restauración deberá contar con autorización del responsable de TI. El DBA será el encargado de ejecutarla y deberá comprobar que la información recuperada esté completa y funcione correctamente.

**Responsable:** El responsable de TI autoriza la restauración y el DBA la ejecuta y verifica.

**Excepciones:** En una emergencia que afecte la operación, el responsable de TI podrá autorizar una restauración inmediata, dejando registro de la decisión.

**Evidencia:** Actualmente no existe evidencia de una restauración realizada en los laboratorios. El procedimiento técnico se definirá en la Unidad V.

**Revisión:** Cada seis meses.