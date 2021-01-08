module server.message;

import server.settings;
import vibe.d;

public class MessageHandler {
    private Settings settings;

    this(
        Settings settings
    ) {
        this.settings = settings;
    }

    void binary(ubyte[] ubyteArray) {}

    void text(string text) {}
}