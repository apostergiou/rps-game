require 'socket'
require_relative 'game'

def welcome(player)
  player.print "Welcome! Please enter your name: "
  player.readline.chomp
end

s = TCPServer.new(3939)
threads = []
2.times do |n|
  conn = s.accept
  threads << Thread.new(conn) do |c|
    Thread.current[:number] = n + 1
    Thread.current[:player] = c
    player_name = welcome(conn)
    Thread.current[:name] = player_name
    c.puts "Welcome, #{player_name}, you are player #{n + 1}!"
    c.print "Your move? (rock, paper, scissors) "
    Thread.current[:move] = c.gets.chomp
    c.puts "Thanks... hang on."
  end
end

a, b = threads
a.join
b.join
rps1 = Games::RPS.new(a[:move], a[:name])
rps2 = Games::RPS.new(b[:move], b[:name])
winner = rps1.play(rps2)
result = winner ? winner.move : "TIE!"

threads.each do |t|
  if result == "TIE!"
    t[:player].puts "The result is TIE!"
  else
    t[:player].puts "The winner is #{winner.name}!"
    t[:player].puts "The winning move is #{result}!"
  end
end
