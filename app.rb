require 'nokogiri'
require 'open-uri'
require 'sinatra'

#ALGORITHM START
#Global Variables
$price 		        = [50, 100, 150, 200, 500, 3000]
$goan_items		    = ['Beer', 'Fish Thali', 'Port Wine', 'Feni', 'Cashewnuts', 'EDM Festival Pass']
$goan_itemsImage	= ['beer.png', 'FishThali.png', 'Wine.png', 'Feni.png', 'Cashew.png', 'music.png']
$goan_itemsAmount	= [20, 50, 5, 10, 15, 1]
$n    			    = $price.count
#puts $n
#max value is a global variable used to store max accumulated value from the algorithm
$max_val = 0
#vector to store best accumulated values of multiplier from the algorithm
$max_mul = []

#finds the closest value to the target from given subset
def find_closest_value(target, item_count, acc_sum, k, multi)
	puts "calling function"

  #puts "k = " + k.to_s + " acc_sum = " + acc_sum.to_s + " multi = " + multi.to_s
  #puts "k = " + k.to_s + " multi = " + multi.to_s
  #item_count.each { |x| puts x }


  #checks current accumulated value with current max value to find the best match of given subset
  if acc_sum  > $max_val
    $max_val  = acc_sum
    #puts "max value set " + acc_sum.to_s
    #item_count.each { |x| puts x }
    $max_mul  = item_count
    puts "#{item_count}"
    return item_count
  end

  #item_count contains the list of multipliers. is set here to the multiplier value
  item_count[k] = multi
  #item_count.insert(k, multi)
  puts multi.to_s
  #BASE CASE TO END RECURSION
  if multi == 0
    return 0
  end

  #If exact match found to target the max value is set and returns false to destroy whole recursive stack
  if acc_sum + $price[k] * item_count[k] == target
    $max_val = acc_sum + $price[k] * item_count[k]
    #item_count[k] = item_count[k] + 1
    puts "max value set " + $max_val.to_s
    $max_mul = item_count
    $max_mul.each { |x| puts x }
    return false

#This step used to go deeper into the recursive stack only if more elements are present in the given set
#And also checks if current value + old accumulated value doesnt exceed the target sum given
  elsif k + 1 < $n && acc_sum + $price[k] * item_count[k] <= target
    item_count = find_closest_value(target, item_count, acc_sum + $price[k] * item_count[k], k+1, (target-$price[k] * item_count[k])/$price[k+1])
    #used to destroy recursion when perfect match is found
    puts "Next max value set " + $max_val.to_s
    if item_count == false
      return false
    end
  end

  # if k+1 < $n && acc_sum + $price[k] * (item_count[k-1] - 1) + ((target - acc_sum) / $price[k + 1]) * $price[k + 1] <= target
  #   item_count[k] = item_count[k] - 1
  #   find_closest_value(target, item_count, acc_sum + $price[k] * item_count[k - 1], k+1, (target - acc_sum)/$price[k+1])
  # end

  # elsif
  temp = [0,0,0,0,0,0]
  #puts "k last = " + k.to_s
  #item_count.each { |x| puts x }
  #recursive call with multiplier reduced by 1 for the same element in the set
  find_closest_value(target, temp, acc_sum, k, multi - 1)
  # end
end

#routes start - get
get '/' do
	@title = "Search"
	@link = "http://www.flipkart.com"
	@image = "http://img1a.flixcart.com/img/thumb-default.jpg"
	@hideId = "0"
	@productName = nil
	@price = nil
	@itemName = Array.new
	@itemMul = Array.new
	@itemVal = Array.new
	@itemImg = Array.new
	erb :fixedHeaders
end

get '/alg' do
	
end

#routes - post
post '/' do
	#product = "galaxy s5"
	product = params[:search]

	if product.include?" "
		product.gsub!(" ","+")
	end

	url = "http://www.flipkart.com/search?q=" + product
	doc = Nokogiri::HTML(open(url))
	
	# if the data is displayed in 4 per columns
	if(doc.at_css(".unit-4") != nil)
		#puts "unit 4"
		@hideId = "1"
		@link = "http://www.flipkart.com" + doc.at_css(".unit-4 .pu-visual-section a")["href"]
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		@productName = doc.at_css(".unit-4 .pu-details .pu-title").text.strip
		puts doc.at_css(".unit-4 .pu-details .pu-title").text.strip
		@price = doc.at_css(".unit-4 .pu-details .pu-price .pu-final").text.strip
		target2 = doc.at_css(".unit-4 .pu-details .pu-price .pu-final").text.strip
		url = @link
		doc = Nokogiri::HTML(open(url))
		@image = doc.at_css(".top-section .left-col-wrap .left-col .productImages .innerPanel .mainImage .imgWrapper img")["data-src"]
	# if the data is displayed in 3 per columns
	elsif(doc.at_css(".unit-4") == nil && doc.at_css(".unit-3") != nil)
		#puts "unit 3"
		@hideId = "1"
		@link = "http://www.flipkart.com" + doc.at_css(".unit-3 .pu-visual-section a")["href"]
		#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
		@productName = doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		puts doc.at_css(".unit-3 .pu-details .pu-title").text.strip
		@price = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		target2 = doc.at_css(".unit-3 .pu-details .pu-price .pu-final").text.strip
		url = @link
		doc = Nokogiri::HTML(open(url))
		@image = doc.at_css(".top-section .left-col-wrap .left-col .productImages .innerPanel .mainImage .imgWrapper img")["data-src"]
	# if data is not in 3||4 per columns
	else
		@hideId = "0"
		target2 = "0"
		puts "no units"
	end

		# converting string to integer
	if target2.include?"Rs. "
		target2.gsub!("Rs. ","")
		#puts "found"
	end

	if target2.include?","
		target2.gsub!(",","")
		#puts "found"
	end

	target = target2.to_i
	#take care of 999 type values of an online product
	if (target + 1) % 100 == 0
		target = target + 1
	end

	#initialization of all variables
	item_count = [0,0,0,0,0,0]
	acc_sum = 0
	multi = 0
	#creating randomness in the output
	k = rand(5)
	multi = target / $price[k]
	#puts @price+target.to_s
	puts "#{multi}"
	puts "Function called"
	item_count = find_closest_value(target, item_count, acc_sum, k, multi)

	# puts " item list "
	# $max_mul.each { |x| puts x }
	# puts " max val = " + $max_val.to_s
	puts "#{item_count}"
	#HASH defined to store only product and corresponding quantity to be displayed on the site
	final_items = Hash.new
	final_items_image = Hash.new
	@itemName = Array.new
	@itemMul = Array.new
	@itemVal = Array.new
	@itemImg = Array.new	
	i = 0
	j = 0

	if @itemName.any? == false
		puts "False"
	end

	while i < $n do
  		if $max_mul[i] != 0
	   		final_items[$goan_items[i]] = $max_mul[i]
	   		@itemName[j] = $goan_items[i]
	   		@itemMul[j] = $max_mul[i].to_s
	   		@itemImg[j] = $goan_itemsImage[i]
	   		@itemVal[j] = $goan_itemsAmount[i]
	   		puts "Initial max val:" + $max_mul[i].to_s
	   		#final_items_image[$goan_items[i]] = $goan_itemsImage[i]
	   		j = j + 1
		end
  		i = i + 1
	end

	if @itemName.any?
		puts "True"
	end

	#puts "hash values : "
	# final_items.each do |key, value|
 #    	puts key + " : " + value.to_s
 #    	@altProduct = key
 #    	@altValue = value.to_s
 #    	@altImage = "images/" + key + ".png"
	# end
	
	#redirect to("/")
<<<<<<< HEAD
	erb :fixedHeaders
END
=======
	erb :fixedHeaders1
end

#ALGORITHM START

$price 		        = [50, 100, 150, 200, 500, 3000]
goan_items		    = ['Beer', 'Fish Thali', 'Port Wine', 'Feni', 'Cashewnuts', 'EDM Festival Pass']
$n    			    = $price.count
#puts $n

#finds the closest value to the target from given subset
def find_closest_value(target, item_count, acc_sum, k, multi)

  #puts "k = " + k.to_s + " acc_sum = " + acc_sum.to_s + " multi = " + multi.to_s
  #puts "k = " + k.to_s + " multi = " + multi.to_s
  #item_count.each { |x| puts x }


  #checks current accumulated value with current max value to find the best match of given subset
  if acc_sum  > $max_val
    $max_val  = acc_sum
    #puts "max value set " + acc_sum.to_s
    #item_count.each { |x| puts x }
    $max_mul  = item_count
    
    return item_count
  end

  #item_count contains the list of multipliers. is set here to the multiplier value
  item_count[k] = multi
  #item_count.insert(k, multi)

  #BASE CASE TO END RECURSION
  if multi == 0
    return 0
  end

  #If exact match found to target the max value is set and returns false to destroy whole recursive stack
  if acc_sum + $price[k] * item_count[k] == target
    $max_val = acc_sum + $price[k] * item_count[k]
    #item_count[k] = item_count[k] + 1
    puts "max value set " + $max_val.to_s
    $max_mul = item_count
    $max_mul.each { |x| puts x }
    return false

#This step used to go deeper into the recursive stack only if more elements are present in the given set
#And also checks if current value + old accumulated value doesnt exceed the target sum given
  elsif k + 1 < $n && acc_sum + $price[k] * item_count[k] <= target
    item_count = find_closest_value(target, item_count, acc_sum + $price[k] * item_count[k], k+1, (target-$price[k] * item_count[k])/$price[k+1])
    #used to destroy recursion when perfect match is found
    if item_count == false
      return false
    end
  end

  # if k+1 < $n && acc_sum + $price[k] * (item_count[k-1] - 1) + ((target - acc_sum) / $price[k + 1]) * $price[k + 1] <= target
  #   item_count[k] = item_count[k] - 1
  #   find_closest_value(target, item_count, acc_sum + $price[k] * item_count[k - 1], k+1, (target - acc_sum)/$price[k+1])
  # end

  # elsif
  temp = [0,0,0,0,0,0]
  #puts "k last = " + k.to_s
  #item_count.each { |x| puts x }
  #recursive call with multiplier reduced by 1 for the same element in the set
  find_closest_value(target, temp, acc_sum, k, multi - 1)
  # end
end


target = 10000
#take care of 999 type values of an online product
if (target + 1) % 100 == 0
	target = target + 1
end

#initialization of all variables
item_count = [0,0,0,0,0,0]
acc_sum = 0
multi = 0
#creating randomness in the output
k = rand(5)
multi = target / $price[k]

#max value is a global variable used to store max accumulated value from the algorithm
$max_val = 0
#vector to store best accumulated values of multiplier from the algorithm
$max_mul = []

item_count = find_closest_value(target, item_count, acc_sum, k, multi)

# puts " item list "
# $max_mul.each { |x| puts x }
# puts " max val = " + $max_val.to_s

#HASH defined to store only product and corresponding quantity to be displayed on the site
final_items = Hash.new
i = 0

while i < $n do
  if $max_mul[i] != 0
	   final_items[goan_items[i]] = $max_mul[i]
	end
  i = i + 1
end

puts "hash values : "
final_items.each do |key, value|
    puts key + " : " + value.to_s
end
>>>>>>> 4fd91d55dfc94bdaa21c0dfa73f22d09996e8b38
