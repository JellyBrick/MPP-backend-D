module server.database;

import std.stdio;
import std.file;
import std.path;
import std.conv;
import std.typecons : tuple, Tuple;

import fastJson = fast.json;
import vibeJson = vibe.data.json;

class Database {
    private string dir;

    public struct PlayerInfo {
        uint color = 0;
        string name = "";
    }

    this(immutable string dir) {
        this.dir = dir;

        if (!this.dir.exists()) {
            this.dir.mkdir();
        }
    }

    Tuple!(bool, PlayerInfo) getUserInfo(uint hash) {
        auto filePath = dir ~ pathSeparator ~ to!string(hash);
        if (filePath.exists()) {
            return tuple(true, fastJson.parseJSONFile(filePath).read!(PlayerInfo));
        } else {
            PlayerInfo info;
            return tuple(false, info);
        }
    }

    void setUserInfo(immutable PlayerInfo info, uint hash) {
        auto filePath = dir ~ pathSeparator ~ to!string(hash);

        File(filePath, "w").write(vibeJson.Json([
            "color": vibeJson.Json(info.color),
            "name": vibeJson.Json(info.name)
        ]).toString());
    }
}