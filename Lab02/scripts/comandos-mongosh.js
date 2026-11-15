
db.version();

db.adminCommand({ buildInfo: 1 }).modules;

db.serverCmdLineOpts().parsed;

db.getProfilingStatus();

db.clientes.updateOne(
    { _id: 3 },
    { $set: { rfc: "GAMA780912XXX" } }
);

db.system.profile.countDocuments();

function bitacora() {
    return db.adminCommand({ getLog: "global" }).log.map(
        l => JSON.parse(l)
    );
}

db.setProfilingLevel(2);

db.clientes.find(
    { ciudad: "Culiacán" },
    { nombre: 1, ciudad: 1 }
).toArray();

db.clientes.updateOne(
    { _id: 3 },
    { $set: { rfc: "GAMA780912XYZ" } }
);

db.clientes.deleteOne({ _id: 2 });

db.system.profile.find(
    { ns: "comercial.clientes" }
).sort({ ts: 1 });

db.setProfilingLevel(0);

db.system.profile.drop();

db.setProfilingLevel(1, {
    filter: {
        op: { $in: ["insert", "update", "remove"] }
    }
});

db.clientes.find({ _id: 1 }).toArray();

db.clientes.updateOne(
    { _id: 1 },
    { $set: { telefono: "6670000000" } }
);

db.system.profile.find({});

bitacora().filter(
    e => e.c === "ACCESS" && e.msg === "Failed to authenticate"
);

bitacora().filter(
    e => e.msg === "Successfully authenticated" &&
         e.attr.user === "app_ventas"
);

bitacora().filter(
    e => e.msg === "Profiler settings changed"
);

bitacora().filter(
    e => e.ctx === "conn31" &&
         e.msg === "Successfully authenticated"
);

db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
    momento: new Date(),
    tomada_por: db.runCommand({
        connectionStatus: 1
    }).authInfo.authenticatedUsers,
    usuarios: db.getUsers().users.map(u => ({
        user: u.user,
        db: u.db,
        roles: u.roles
    }))
});

db.grantRolesToUser(
    "app_ventas",
    [{ role: "dbAdmin", db: "comercial" }]
);

db.system.profile.countDocuments({
    "command.grantRolesToUser": { $exists: true }
});

bitacora().filter(
    e => JSON.stringify(e).includes("grantRoles")
).length;

db.getSiblingDB("auditoria").instantaneas_privilegios.insertOne({
    momento: new Date(),
    tomada_por: db.runCommand({
        connectionStatus: 1
    }).authInfo.authenticatedUsers,
    usuarios: db.getUsers().users.map(u => ({
        user: u.user,
        db: u.db,
        roles: u.roles
    }))
});

db.getSiblingDB("auditoria")
    .instantaneas_privilegios
    .find({})
    .sort({ momento: 1 });

db.revokeRolesFromUser(
    "app_ventas",
    [{ role: "dbAdmin", db: "comercial" }]
);

db.setProfilingLevel(1, {
    filter: {
        op: { $in: ["insert", "update", "remove"] }
    }
});

db.getProfilingStatus();

db.system.profile.countDocuments();

db.adminCommand({ getLog: "global" }).log.length;

db.getProfilingStatus();

db.system.profile.countDocuments();

db.adminCommand({ getLog: "global" }).log.length;
