module server.database;

import std.stdio;
import std.file;
import std.path;
import std.conv;
import std.typecons : tuple, Tuple;

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
        import fast.json;
        auto filePath = dir + pathSeparator + to!string(hash);
        if (filePath.exists()) {
            return tuple(true, json.parseJSONFile(filePath).read!(PlayerInfo));
        } else {
            PlayerInfo info;
            return tuple(false, info);
        }
    }

    void setUserInfo(immutable PlayerInfo info, uint hash) {
        import std.json;
        JSONValue jsonObject = ["color": info.color];
        jsonObject.object["name"] = "";

        auto filePath = dir + pathSeparator + to!string(hash);

        File(filePath, "w").write(jsonObject.toString());
    }
}