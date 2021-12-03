counts = []

STDIN.each_line do |l|
  l.strip.split("").each_with_index do |c,i|
    counts[i] ||= {0 => 0, 1 => 0}
    counts[i][c.to_i] += 1
  end
end

gamma = 0
gamma_str = ""
epsilon = 0
epsilon_str = ""

counts.reverse.each_with_index do |l,i|
  puts "#{l[0]} < #{l[1]}"
  if l[0] < l[1] then
    gamma |= 2 ** i
    gamma_str = "1" + gamma_str
    epsilon_str = "0" + epsilon_str
  else
    epsilon |= 2 ** i
    gamma_str = "0" + gamma_str
    epsilon_str = "1" + epsilon_str
  end

  puts gamma_str
  puts gamma.to_s(2)
  puts
  puts epsilon.to_s(2)
  puts epsilon_str
  puts "**"
end

puts gamma*epsilon
