module server.message_handler;

import server.settings;
import vibe.d;
import server.room;
import fastJson = fast.json;
import vibeJson = vibe.data.json;

public class MessageHandler {
    private Settings settings;

    this(
        Settings settings
    ) {
        this.settings = settings;
    }

    void binary(ubyte[] ubyteArray) {

    }

    void text(string text) {
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