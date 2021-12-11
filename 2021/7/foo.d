import std.stdio;
import std.array;
import std.range;
import std.string;
import std.math;
import std.conv;

import std.algorithm.iteration;
import std.algorithm.searching;

void main() {
    string line = stdin.readln();

    string[] crabStrs = line.chomp().split(",");
    int[] crabs = map!(to!int)(crabStrs).array;
    foreach(i ; iota(crabs.minElement, crabs.maxElement)) {
        auto cost = crabs.map!((a) {
                auto dist = abs(a-i);
                return dist*(dist+1)/2;
        });
        auto fuel = cost.sum();
        writeln(fuel);
    }
}
