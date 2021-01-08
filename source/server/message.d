module server.message;

import server.settings;
import vibe.d;
import server.room;

public class MessageHandler {
    private Settings settings;
    private Room[] rooms;

    this(
        Settings settings
    ) {
        this.settings = settings;
    }

    void binary(ubyte[] ubyteArray) {

    }

    void text(string text) {

    }
}