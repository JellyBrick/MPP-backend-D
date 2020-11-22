module server.limiter.simple;

import std.datetime.systime;
import server.limiter.time;

class Simple {
    private float rate;
    private SysTime lastCheck;

    this(float a) {
        this.rate = a;
    }

    bool canSpend() {
        auto now = Clock.currTime();
        immutable auto passed = Time.toFloatUnixTime(now) - Time.toFloatUnixTime(lastCheck);
        lastCheck = now;

        if (passed < rate) {
            return false;
        } else {
            return true;
        }
    }
}