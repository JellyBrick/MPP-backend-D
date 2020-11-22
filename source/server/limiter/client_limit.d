module server.limiter.client_limit;

import server.limiter.simple;

class ClientLimit {
    public Simple name;
    public Simple room;
    public Simple roomList;

    this() {
        this.name = new Simple(2);
        this.room = new Simple(1.6f);
        this.roomList = new Simple(0.8f);
    }
}