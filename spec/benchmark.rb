require File.dirname(__FILE__) + '/../lib/trie'
require 'set'
require 'benchmark'

HEX_CHARACTERS = %w|0 1 2 3 4 5 6 7 8 9 A B C D E F|

def generate_hex_string(length)
  string = ''
  1.upto(length) do
    string << HEX_CHARACTERS[rand(HEX_CHARACTERS.size)]
  end
  string
end

puts "\nPopulating array and set..."
trie = Trie.new
set = Set.new

50_000.times do
  hex_string = generate_hex_string(16)
  trie << hex_string
  set << hex_string
end
puts "done\n\n"

WIDTH = 30

puts '-- Benchmarking #size --'
Benchmark.bmbm(WIDTH) do |x|
  x.report('Try#size:') {trie.size}
  x.report('Set#size:') {set.size}
end
puts "\n"

puts '-- Benchmarking #include? --'
test_hex_string = generate_hex_string(16)
Benchmark.bmbm(WIDTH) do |x|
  x.report('Try#include?:') {trie.include?(test_hex_string)}
  x.report('Set#include?:') {set.include?(test_hex_string)}
end
puts "\n"

puts '-- Benchmarking #add --'
test_hex_string = generate_hex_string(16)
Benchmark.bmbm(WIDTH) do |x|
  x.report('Try#add:') {trie.add(test_hex_string)}
  x.report('Set#add:') {set.add(test_hex_string)}
end
puts "\n"

puts '-- Benchmarking #prefixed_by --'
test_hex_string = generate_hex_string(10)
Benchmark.bmbm(WIDTH) do |x|
  x.report('Try#prefixed_by:') {trie.prefixed_by(test_hex_string)}
  x.report('Set prefixed_by equivalent:') {set.select{|hex| hex[0..(test_hex_string.length - 1)] == test_hex_string}}
end
puts "\n"
