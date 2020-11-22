module server.main;

import server.settings;
import server.router;
import dlogg.log;
import dlogg.buffered;
import dlogg.strict;
import argon;

public class MainHandler {
    private shared StrictLogger logger = new shared StrictLogger("server.log");

    this() {
        logger.minOutputLevel = LoggingLevel.Notice;
    }

    auto run(string[] args) {
        auto settings = new Settings();

        try {
            settings.Parse(args);
        } catch (argon.ParseException e) {
            logger.logError(e.msg);
            logger.logError(BuildSyntaxSummary);
            return 1;
        }

        auto router = new Router(this);
        router.run();

        return 0;
    }
}