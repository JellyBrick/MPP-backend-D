module server.limiter.bucket;

import std.datetime.systime;
import server.limiter.time;

class Bucket {
    private ushort rate;
    private ushort per;
    private float allowance;
    private SysTime lastCheck;

    this(uint a, uint b) {
        this.rate = a;
        this.per = b;
        this.allowance = cast(float) a;
    }

    bool canSpend(ushort count) {
        auto now = Clock.currTime();
        immutable auto passed = Time.toFloatUnixTime(now) - Time.toFloatUnixTime(lastCheck);
        lastCheck = now;

        allowance += passed * (cast(float) rate / per);
        if (allowance > rate) {
            allowance = rate;
        }
        if (allowance < count) {
            return false;
        } else {
            allowance -= count;
            return true;
        }
    }
}