require 'nokogiri'
require 'open-uri'
require 'sinatra'

get '/' do
	@title = "Search"
	@link = "http://www.flipkart.com"
	@image = "http://img1a.flixcart.com/img/thumb-default.jpg"
	@productName = nil
	@price = nil
	erb :index
end

post '/' do
	#product = "galaxy s5"
	product = params[:search]

	if product.include?" "
		product.gsub!(" ","+")
	end
	
	url = "http://www.flipkart.com/search?q=" + product
	doc = Nokogiri::HTML(open(url))
	
	@link = "http://www.flipkart.com" + doc.at_css(".unit-4 .pu-visual-section a")["href"]
	#@image = doc.at_css(".unit-4 .pu-visual-section .fk-product-thumb img")["data-src"]
	@productName = doc.at_css(".unit-4 .pu-details .pu-title").text.strip
	puts doc.at_css(".unit-4 .pu-details .pu-title").text.strip
	@price = doc.at_css(".unit-4 .pu-details .pu-price .pu-final").text.strip

	url = @link
	doc = Nokogiri::HTML(open(url))
	@image = doc.at_css(".top-section .left-col-wrap .left-col .productImages .innerPanel .mainImage .imgWrapper img")["data-src"]

	#redirect to("/")
	erb :index
end

