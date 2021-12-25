import java.util.List;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import java.io.FileReader;
import java.io.BufferedReader;
import java.io.FileNotFoundException;

public class Twelve {

  public static class Node {
    public String name;
    public Set<Node> neighbors;

    public Node() {
      neighbors = new HashSet<Node>();
    }
  }

  public static final void main(String[] args) {
    try {
      BufferedReader r = new BufferedReader(new FileReader("test.txt"));
      HashMap<String, Node> nodes = new HashMap<String, Node>();
      r.lines().forEach(l -> {
        String[] sp = l.split("-");
        Node left = nodes.get(sp[0]);
        if(left == null) {
            left = new Node();
            left.name = sp[0];
            nodes.put(sp[0], left);
        }
         Node right = nodes.get(sp[1]);
         
        if(right == null) {
          right = new Node();
               right.name = sp[1];
            nodes.put(sp[1], right);

        }
        
        left.neighbors.add(right);
        right.neighbors.add(left);

        System.out.println(left);
      });

    } catch (FileNotFoundException e) {
      System.err.println("foo");
      return;
    }
  }
}
