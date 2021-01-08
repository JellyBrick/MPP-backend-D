module server.router;

import server.settings;
import server.message;
import vibe.d;
import vibe.utils.array;

public class Router {
    private auto urlRouter = new URLRouter();
    private auto httpServerSettings = new HTTPServerSettings();
    private MessageHandler handler;

    this(Settings settings) {
        handler = new MessageHandler(settings);
        urlRouter.get("*", handleWebSockets(&handleWebSocketConnection));

        httpServerSettings.port = settings.port;
        httpServerSettings.bindAddresses = [settings.ipv6Address, settings.ipv4Address];
    }

    void handleWebSocketConnection(scope WebSocket socket) {
        while (socket.connected) {
            bool isBinary = false;
            ubyte[] ubyteArray = null;
            string text = null;
            socket.receive((scope IncomingWebSocketMessage message) @safe {
                if (message.frameOpcode == 0x2) { // binary
                    isBinary = true;
                    ubyteArray = message.readAll();
                } else if (message.frameOpcode == 0x1) { // text
                    text = message.readAllUTF8();
                } else {
                    socket.close();
                    return;
                }
            });

            if (isBinary) {
                handler.binary(ubyteArray);
            } else {
                handler.text(text);
            }
        }
    }

    void run() {
        listenHTTP(this.httpServerSettings, this.urlRouter);
    }
}