module server.message_handler;

import std.typecons;
import server.client;
import server.settings;
import server.room;
import vibe.d;
import vibe.utils.hashmap;
import fastJson = fast.json;
import vibeJson = vibe.data.json;

public class MessageHandler {
    private Settings settings;
    private HashMap!(string, Room) rooms; // Room name, Room
    private HashMap!(string, Tuple!(Client, HashMap!(WebSocket, string))) clients; // IP string, Tuple<Client, HashMap<WebSocket, string>>

    this(
        Settings settings
    ) {
        this.settings = settings;
    }

    void binary(ubyte[] ubyteArray, WebSocket socket) {
        immutable auto arrLength = ubyteArray.length;
        if (arrLength < 12) {
            return;
        }
        // very simple filter
        for (size_t x = 9; x < arrLength; x += 3) {
            if (ubyteArray[x] > 87) {
                return;
            }
        }
        auto client = clients.get(socket.request.clientAddress.toString());
        if (client != HashMap.Value.init) {
            auto room = rooms.get(client.sockets);
            if (
                room != HashMap.Value.init &&
                (!room.getRoomSettings().canPlayOwnerOnly || room.getCrownInfo().owner == client)
            ) {
                // TODO: Implement bin_n
            }
        }
    }

    void text(string text, WebSocket socket) {
        auto json = vibeJson.parseJsonString(text);
        foreach (Json value; json) {
            auto rawMessage = value["m"];
            if (rawMessage.type == vibeJson.Json.Type.string) {
                auto textHandler = new TextHandler(value);
                final switch (rawMessage.get!string()) {
                    case "n": textHandler.n(); break;
                    case "a": textHandler.a(); break;
                    case "m": textHandler.m(); break;
                    case "t": textHandler.t(); break;
                    case "ch": textHandler.ch(); break;
                    case "hi": textHandler.hi(); break;
                    case "chown": textHandler.chown(); break;
                    case "userset": textHandler.userset(); break;
                    case "adminmsg": textHandler.adminmsg(); break;
                    case "kickban": textHandler.kickban(); break;
                    case "-ls": textHandler.lsMinus(); break;
                    case "+ls": textHandler.lsPlus(); break;
                }
            }
        }
    }

    private class TextHandler {
        private Json json;

        this(
            Json json
        ) {
            this.json = json;
        }

        void n() {
            
        }
        
        void a() {

        }

        void m() {

        }

        void t() {

        }

        void ch() {

        }

        void hi() {

        }

        void chown() {

        }

        void chset() {

        }

        void userset() {

        }

        void adminmsg() {

        }

        void kickban() {

        }

        void lsMinus() {

        }

        void lsPlus() {

        }
    }
}