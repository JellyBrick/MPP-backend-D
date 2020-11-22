module app;

import std.stdio;
import server;

int main(string[] args) {
	auto mainHandler = new MainHandler();
	return mainHandler.run(args);
}
