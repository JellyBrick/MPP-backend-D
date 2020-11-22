module server.room;

import server.client;

class Room {
    struct OwnerInfo {
        Client owner;
        Client oldOwner;
        float[2] startPos;
        float[2] endPos;
        long time;
    }

    struct RoomSetting {
        bool looby;
        bool visible;
        bool chat;
        bool canPlayOwnerOnly;
        uint color;
    }

    RoomSetting settings;
    OwnerInfo ownerInfo;
}