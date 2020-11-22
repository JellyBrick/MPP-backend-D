module server.room;

import containers.hashset;
import container.queue;
import vibe.d;
import vibe.utils.hashmap;
import vibe.data.json;
import std.typecons;
import std.format;
import server.client;
import server.settings;
import server.limiter.room_limit;

class Room {
    class ClientInfo {
        HashSet!(WebSocket) sockets;
        RoomLimit quota;
        string id;
        float x;
        float y;
    }

    struct CrownInfo {
        Client owner;
        Client oldOwner;
        float[2] startPos;
        float[2] endPos;
        long time;
    }

    struct RoomSettings {
        bool isLobby;
        bool visible;
        bool enableChat;
        bool canPlayOwnerOnly;
        uint color;
    }

    private RoomSettings settings;
    private CrownInfo crownInfo;
    private HashMap!(string, long) bannedUser;
    private GrowableCircularQueue!Json chatLog;

    public HashMap!(Client, ClientInfo) ids;

    this(bool lobby, Settings settings) {
        this.settings.isLobby = lobby;
        this.settings.visible = true;
        this.settings.enableChat = true;
        this.settings.canPlayOwnerOnly = false;
        this.settings.color = settings.roomColor;
        this.crownInfo = CrownInfo(null, null, [50, 50], [50, 50], 0);
    }

    Json getChatLogJson() {
        Json log;
        import std.range;
        foreach (i; 0 .. this.chatLog.length) {
            log ~= this.chatLog[i];
        }
        return log;
    }

    void pushChat(Json j) {
        chatLog.push(j);
        if (chatLog.length > 32) {
            chatLog.pop();
        }
    }

    Json getJson(immutable string channelId, bool includePpl) {
        auto j = Json([
            "m": Json("ch"),
            "ch": Json([
                "_id": Json(channelId),
                "count": Json(ids.length()),
                "settings": Json([
                    "visible": Json(this.settings.visible),
                    "chat": Json(this.settings.enableChat),
                    "lobby": Json(this.settings.isLobby),
                    "crownsolo": Json(this.settings.canPlayOwnerOnly),
                    "color": Json('#' ~ to!string(this.settings.color, 16))
                ])
            ])
        ]);
        if (includePpl) {
            if (!this.settings.isLobby) {
                if (this.crownInfo.owner !is null) {
                    auto owner = this.crownInfo.owner;
                    auto value = ids.get(owner, null);
                    if (value !is null) {
                        j["ch"]["crown"] = Json([
                            "participantId": Json(value.id),
                            "userId": Json(owner.uniqueId)
                        ]);
                    }
                } else {
                    j["ch"]["crown"] = Json([
                        "time": Json(this.crownInfo.time),
                        "startPos": Json([
                            "x": Json(this.crownInfo.startPos[0].format!("%.2f")),
                            "y": Json(this.crownInfo.startPos[1].format!("%.2f")),
                        ]),
                        "endPos": Json([
                            "x": Json(this.crownInfo.endPos[0].format!("%.2f")),
                            "y": Json(this.crownInfo.endPos[1].format!("%.2f")),
                        ])
                    ]);
                }
            }
            Json ppl;
            foreach (Client index, ClientInfo value; ids) {
                auto inf = index.getJson();
                inf["x"] = value.x.format!("%.2f");
                inf["y"] = value.y.format!("%.2f");
                inf["id"] = value.id;
                ppl ~= inf;
            }
            j["ppl"] = ppl;
        }
        return j;
    }
}