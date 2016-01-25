Target = 25400
#Beer, Fish Thali, Port Wine, Feni, Cashewnuts, EDM Festival Pass
GoanItems = [50, 100, 150, 200, 500, 3000]
Percent = [40,40,20]
Preference = [50,250,100,5000,150,200]
a = 1+rand(3)
puts a

p1 = Target * 0.4
p1 = p1.to_i
p2 = Target * 0.4
p2 = p2.to_i
p3 = Target * 0.2
p3 = p3.to_i

p4 = Target * 0.33
p4 = p4.to_i

case a
when 1
  puts "Number of Beer bottles : " + (p1/GoanItems[0]).to_s
  puts "Number of Fish Thalis: " + (p2/GoanItems[1]).to_s
  puts "Number of bottles of Port Wine: " + (p3/GoanItems[2]).to_s
  leftover = Target - ((p1/GoanItems[0])*GoanItems[0] + (p2/GoanItems[1])*GoanItems[1] + (p3/GoanItems[2])*GoanItems[2])
  puts "Leftover unused = " + leftover.to_s
  if leftover > 50
    additional_beer = leftover/50
    puts "Revised Number of beer bottles: " + (p1/GoanItems[0] + additional_beer).to_s
  end

when 2
  puts "Number of EDM Festival Passes : " + (p1/GoanItems[5]).to_s
  puts "KG of Cashewnuts: " + (p2/GoanItems[4]).to_s
  puts "Number of bottles of Feni: " + (p3/GoanItems[3]).to_s
  leftover = Target - ((p1/GoanItems[5])*GoanItems[5] + (p2/GoanItems[4])*GoanItems[4] + (p3/GoanItems[3])*GoanItems[3])
  puts "Leftover unused = " + leftover.to_s
  if leftover > 50
    additional_beer = leftover/50
    puts "And number of beer bottles is: " + additional_beer.to_s
  end

when 3
  puts "Number of bottles of Beer: " + (p4/Preference[0]).to_s
  puts "KG of Cashewnuts: " + (p4/Preference[1]).to_s
  puts "Number of Fish Thalis: " + (p4/Preference[2]).to_s
  leftover = Target - ((p4/Preference[0])*Preference[0] + (p4/Preference[1])*Preference[1] + (p4/Preference[2])*Preference[2])
  puts "Leftover unused = " + leftover.to_s
  if leftover > 50
    additional_beer = leftover/50
    puts "And number of beer bottles is: " + additional_beer.to_s
  end
end

# if leftover > 50
#   additional_beer = leftover/50
#   puts "Revised Number of beer bottles: " + (p1/GoanItems[] + additional_beer).to_s
# end
