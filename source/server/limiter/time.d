module server.limiter.time;

import core.time;
import std.datetime.systime;

class Time {
    static float toFloatUnixTime(immutable SysTime time) {
        return (time - SysTime.fromUnixTime(0)).total!"msecs" / 1000.0;
    }
}