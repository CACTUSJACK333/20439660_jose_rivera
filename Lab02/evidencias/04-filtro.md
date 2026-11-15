#### Actividad 4 — Reducir el volumen con un filtro

**1. ¿Qué perdiste de evidencia al aplicar el filtro? ¿Qué ganaste?**

Al aplicar el filtro dejé de registrar operaciones como las consultas `find` y otras que no fueran inserciones, actualizaciones o eliminaciones. A cambio, obtuve registros más específicos y fáciles de revisar, además de reducir la cantidad de información almacenada.

**2. ¿Qué filtro usarías si solo interesaran operaciones sobre la colección `clientes`?**

Utilizaría el campo `ns`, que identifica la base de datos y la colección. El filtro sería:

db.setProfilingLevel(1, {
  filter: {
    ns: "comercial.clientes"
  }
})

De esta manera, MongoDB registraría las operaciones perfilables que se realicen sobre la colección `clientes` de la base de datos `comercial`.