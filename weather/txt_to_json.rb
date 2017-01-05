require 'json'
arr = []
open("weather_id.txt").each do |line|
  next if line == nil
  next if line =~ /^#.*/
  arr << line.chomp.split("\t")
end
print arr.to_h.to_json
