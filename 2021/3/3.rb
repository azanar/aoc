require 'pp'
counts = []
tree = {}

STDIN.each_line do |l|
  subtree = tree
  l.strip.split("").each_with_index do |c,i|
    counts[i] ||= {0 => 0, 1 => 0}
    counts[i][c.to_i] += 1

    if subtree == {} then
      (0..1).each do |cc|
        subtree[cc] ||= {:count => 0, :desc => {}}
      end
    end 

    subtree[c.to_i][:count] += 1
    subtree = subtree[c.to_i][:desc]

  end
end

gamma = 0
gamma_str = ""
epsilon = 0
epsilon_str = ""

counts.reverse.each_with_index do |l,i|
  if l[0] < l[1] then
    gamma |= 2 ** i
    gamma_str = "1" + gamma_str
    epsilon_str = "0" + epsilon_str
  else
    epsilon |= 2 ** i
    gamma_str = "0" + gamma_str
    epsilon_str = "1" + epsilon_str
  end
end

o_gen = ""
trav = tree
while trav != {} do
  if trav[0][:count] > trav[1][:count]
    o_gen += "0"
    trav = trav[0][:desc]
  else
    o_gen += "1"
    trav = trav[1][:desc]
  end
end
pp(o_gen)
pp(o_gen.to_i(2))

co_two_gen = ""
trav = tree
while trav != {} do
  if trav[1][:count] > 0 && (trav[0][:count] == 0 || trav[0][:count] > trav[1][:count])
    co_two_gen += "1"
    trav = trav[1][:desc]
  else
    co_two_gen += "0"
    trav = trav[0][:desc]
  end
end
pp(co_two_gen)
pp(co_two_gen.to_i(2))
