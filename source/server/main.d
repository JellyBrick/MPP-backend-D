module server.main;

import server.settings;
import server.router;
import dlogg.log;
import dlogg.strict;
import argon;

public class MainHandler {
    private shared StrictLogger logger;

    this() {
        logger = new shared StrictLogger("server.log");
        logger.minOutputLevel = LoggingLevel.Notice;
    }

    auto run(string[] args) {
        auto settings = new Settings();

        try {
            settings.Parse(args);
        } catch (argon.ParseException e) {
            logger.logError(e.msg);
            logger.logError(settings.BuildSyntaxSummary);
            return 1;
        }

        auto router = new Router(settings);
        router.run();

        return 0;
    }
}