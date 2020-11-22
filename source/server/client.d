module server.client;

import std.json;
import std.conv;
import server.database;
import server.limiter.client_limit;

class Client {
    private uint color;
    private string name;
    public string uniqueId;
    public uint dbHash;
    public ClientLimit quota;
    public bool changed;

    this(
        uint dbHash,
        string uniqueId,
        uint color,
        string name
    ) {
        this.dbHash = dbHash;
        this.uniqueId = uniqueId;
        this.color = color;
        this.name = name;
    }

    public auto getJson() {
        return JSONValue([
            "name": this.name,
            "color": '#' + to!string(color, 16),
            "_id": this.uniqueId
        ]);
    }

    public auto getDbData() {
        PlayerInfo data;
        data.color = color;
        data.name = name;
        return data;
    }
}