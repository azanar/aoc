import java.util.ArrayDeque;
import java.util.ArrayList;

import java.util.List;
import java.util.Deque;
import java.util.Map;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;


import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;

public class Twelve {



    public static class Node {
        public String name;
        public Set<Node> neighbors;
        public boolean large;

        public Node(String name) {

            this.name = name.strip();

            if (name.matches("[A-Z]+")) {
                this.large = true;
            } else {
                this.large = false;
            }

            neighbors = new HashSet<Node>();
        }

        public void visit(Traversal t) {
            if (name.equals("end")) {
                t.record();
                return;
            }
            t.push(this);

            for(Node nn : neighbors) {

                if (t.canVisit(nn))
                    nn.visit(t);
            }
            t.pop();
        }
    }

    public static class End extends Node {
        public End(String name) {
            super(name);
        }

        public void visit(Traversal t) {
            t.record();
        }
    }

    private static class Traversal {
        public Set<Node> visited;
        public Deque<Node> path;
        public List<List<Node>> paths;
        public Node repeated;

        public Traversal(Node start) {
            visited = new HashSet<Node>();
            path = new ArrayDeque<Node>();
            paths = new ArrayList<List<Node>>();
            path.add(start);
        }

        public void push(Node n) {
            //System.out.println("Pushing " + n.name);
            if (n.name.equals("end")) {
                throw new IllegalArgumentException("can not traverse past end");
            }

            path.push(n);


            if (!n.large) {
                //System.out.println("Small " + n.name);

                if (visited.contains(n)) {
                    //System.out.println("Repeated " + n.name);
                    repeated = n;
                } else {
                    //System.out.println("Add " + n.name);
                    visited.add(n);
                }
            }  
        }

        public void record() {
            //String nn = String.join(",", path.stream().map((n) -> n.name).collect(Collectors.toList()));

            // System.out.println(nn);
            paths.add(new ArrayList<>(path));
        }

        public void pop() {

            Node n = path.pop();
            //System.out.println("Popping " + n.name);

            if (n == repeated) {
                repeated = null;
            }
            else if (!n.large) {
                visited.remove(n);
            }
        }

        public boolean canVisit(Node n) {
            if (n.name.equals("start")) {
                return false;
            }

            if(!n.large) {
                if(repeated != null && visited.contains(n)) {
                    return false;
                }
            }

            return true;
        }
    }

    public static final void main(String[] args) {
        try {
            BufferedReader r = new BufferedReader(new FileReader("input.txt"));
            HashMap<String, Node> nodes = new HashMap<String, Node>();
            r.lines().forEach(l -> {
                String[] sp = l.split("-");
                Node left = nodes.get(sp[0]);
                if (left == null) {
                    left = new Node(sp[0]);
                    nodes.put(sp[0], left);
                }
                Node right = nodes.get(sp[1]);

                if (right == null) {
                    right = new Node(sp[1]);
                    nodes.put(sp[1], right);

                }

                left.neighbors.add(right);
                right.neighbors.add(left);

            });

            nodes.forEach((k,v) -> {
                String nn = String.join(",", v.neighbors.stream().map((n) -> n.name).collect(Collectors.toList()));
                System.out.println("Key: " + k + " Large:" + v.large + " Neighbors: " + nn);
            });

            Node start = nodes.get("start");



            Traversal t = new Traversal(start);

            start.visit(t);

            System.out.println(t.paths.size());
        } catch (FileNotFoundException e) {
            System.err.println("foo");
            return;
        }
    }
}

