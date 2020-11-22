module server.router;

import server.settings;
import vibe.d;
import vibe.utils.array;

public class Router {
    private auto urlRouter = new URLRouter();
    private auto httpServerSettings = new HTTPServerSettings();

    this(Settings settings) {
        urlRouter.get("*", handleWebSockets(&handleWebSocketConnection));

        httpServerSettings.port = settings.port;
        httpServerSettings.bindAddresses = [settings.ipv6Address, settings.ipv4Address];
    }

    void handleWebSocketConnection() {

    }

    void run() {
        listenHTTP(this.httpServerSettings, this.urlRouter);
    }
}