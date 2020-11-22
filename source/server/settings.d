module server.settings;

import dlogg.log;
import dlogg.buffered;
import dlogg.strict;
import argon;

public class Settings: argon.Handler {
    string password;
    ushort port;
    uint roomColor;
    string ipv4Address;
    string ipv6Address;
    string logFileName;

    this() {
        Named("password", password) ('p') ("Admin password");

        Named("port", port) ('P') ("Port number").AddRange(0, 65_535);

        Named("color", roomColor) ('c') ("Default color code for room").AddRange(0, 16_777_215);

        Named("ipv4-address", ipv4Address, "0.0.0.0") ('f') ("IPv4 Host address");

        Named("ipv6-address", ipv4Address, "::") ('s') ("IPv4 Host address");
    }
}