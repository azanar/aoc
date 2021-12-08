import std.stdio;
import std.array;
import std.string;
import std.conv;

import std.algorithm.iteration;
import std.algorithm.searching;

void main() {
    string line = stdin.readln();

    string[] crabStrs = line.chomp().split(",");
    uint[] crabs = map!(to!uint)(crabStrs);
    writeln(crabs.maxElement);
}
