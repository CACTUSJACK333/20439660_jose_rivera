
select
    name as parametro,
    setting as valor_actual,
    source as origen,
    pending_restart as requiere_reinicio
from pg_settings
where name in (
    'listen_addresses',
    'port',
    'ssl',
    'ssl_min_protocol_version',
    'ssl_cert_file',
    'ssl_key_file',
    'ssl_ca_file',
    'password_encryption',
    'max_connections',
    'superuser_reserved_connections',
    'log_connections',
    'log_disconnections',
    'log_destination',
    'logging_collector',
    'hba_file',
    'config_file',
    'data_directory'
)
order by name;


select
    line_number,
    type as tipo_conexion,
    database as bases_datos,
    user_name as usuarios,
    address as direccion_permitida,
    auth_method as metodo_autenticacion,
    options as opciones,
    error
from pg_hba_file_rules
order by line_number;


select
    rolname as rol,
    rolsuper as superusuario,
    rolcreaterole as puede_crear_roles,
    rolcreatedb as puede_crear_bases,
    rolcanlogin as puede_iniciar_sesion,
    rolreplication as puede_replicar,
    rolbypassrls as omite_seguridad_por_filas,
    rolconnlimit as limite_conexiones
from pg_roles
order by rolsuper desc, rolname;


select
    datname as base_datos,
    datacl as permisos
from pg_database
order by datname;


select
    miembro.rolname as rol_miembro,
    grupo.rolname as rol_concedido,
    m.admin_option as puede_administrar_membresia
from pg_auth_members m
join pg_roles grupo
    on grupo.oid = m.roleid
join pg_roles miembro
    on miembro.oid = m.member
order by miembro.rolname, grupo.rolname;


select
    e.extname as extension,
    e.extversion as version,
    n.nspname as esquema
from pg_extension e
join pg_namespace n
    on n.oid = e.extnamespace
order by e.extname;


select
    a.pid,
    a.usename as usuario,
    a.datname as base_datos,
    a.client_addr as direccion_cliente,
    s.ssl as usa_tls,
    s.version as version_tls,
    s.cipher as cifrado
from pg_stat_activity a
left join pg_stat_ssl s
    on s.pid = a.pid
where a.pid = pg_backend_pid();


select
    datname as base_datos,
    usename as usuario,
    client_addr as direccion_cliente,
    state as estado,
    count(*) as cantidad_conexiones
from pg_stat_activity
where backend_type = 'client backend'
group by
    datname,
    usename,
    client_addr,
    state
order by cantidad_conexiones desc, base_datos, usuario;


select
    name as parametro,
    setting as valor_actual,
    unit as unidad,
    short_desc as descripcion
from pg_settings
where name in (
    'max_connections',
    'superuser_reserved_connections',
    'statement_timeout',
    'idle_in_transaction_session_timeout',
    'password_encryption',
    'ssl',
    'ssl_min_protocol_version',
    'log_connections',
    'log_disconnections'
)
order by name;


select
    sourcefile as archivo,
    sourceline as linea,
    name as parametro,
    setting as valor_configurado,
    applied as aplicado,
    error
from pg_file_settings
where error is not null
   or applied = false
order by sourcefile, sourceline;


select
    name as elemento,
    setting as ruta
from pg_settings
where name in (
    'config_file',
    'hba_file',
    'data_directory',
    'ident_file'
)
order by name;
