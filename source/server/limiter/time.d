module server.limiter.time;

import core.time;
import std.datetime.systime;

class Time {
    private static immutable auto standardUnixTime = SysTime.fromUnixTime(0);

    static float toFloatUnixTime(immutable SysTime time) {
        return (time - standardUnixTime).total!"msecs" / 1000.0;
    }
}