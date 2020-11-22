module server.limiter.room_limit;

import server.limiter.simple;
import server.limiter.bucket;

class RoomLimit {
    public Simple cursors;
    public Bucket chat;

    this() {
        this.cursors = new Simple(0.045f);
        this.chat = new Bucket(4, 5);
    }
}