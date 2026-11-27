comment on table public.clientes is
'Clientes de Comercializadora Norte. Propietario: Gerencia Comercial. Custodio: DBA. Clasificacion: confidencial (contiene datos personales).';

comment on column public.clientes.id is
'Identificador interno del cliente. Generado por el sistema.';

comment on column public.clientes.nombre is
'Nombre completo. Dato personal identificador directo.';

comment on column public.clientes.correo is
'Correo de contacto. Dato personal. Uso: notificaciones al cliente.';

comment on column public.clientes.rfc is
'RFC del cliente. Dato personal. Uso: facturacion. Cambios auditados en auditoria.cambios_clientes.';

comment on column public.clientes.edad is
'Edad en años cumplidos. Dato personal. Uso: analitica agregada.';

comment on column public.clientes.telefono is
'Telefono de contacto del cliente. Dato personal. Uso: comunicacion con el cliente.';

comment on column public.clientes.ciudad is
'Ciudad de residencia del cliente. Dato personal. Uso: informacion comercial.';

comment on column public.clientes.codigo_postal is
'Codigo postal del domicilio del cliente. Dato personal. Uso: ubicacion geografica.';

comment on column public.clientes.fecha_alta is
'Fecha en que el cliente fue registrado en el sistema.';

comment on column public.clientes.segmento is
'Categoria comercial asignada al cliente. Uso: clasificacion de clientes.';

select
    c.ordinal_position as pos,
    c.column_name as columna,
    c.data_type as tipo,
    c.character_maximum_length as longitud,
    c.is_nullable as acepta_nulos,
    c.column_default as valor_por_defecto,
    col_description(
        'public.clientes'::regclass,
        c.ordinal_position
    ) as descripcion
from information_schema.columns c
where c.table_schema = 'public'
  and c.table_name = 'clientes'
order by c.ordinal_position;