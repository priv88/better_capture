require "rubygems"
require "nokogiri"
require "open-uri"
require "capybara"
require "httparty"
require "pp"
require 'pry-byebug'
require 'timeout'
require "writeexcel"
require "csv"
require_relative 'capture_address.rb'


url = CSV.read("links.csv")

url.each do |link|
	main_link = CaptureAddress.new(link[0])
	# binding.pry
	main_link.start_cache
	main_link.check_for_popups
	binding.pry
	main_link.check_for_zipcode
	# binding.pry
	main_link.check_for_state
	
end


#Procedures
#Go to website
#Try to find any address 
#Check if there are any links for Contact / Contact Us 
#Try to find any address indicator (regex for zipcode)

#regex for zipcode
#^\d{5}(?:[-\s]\d{4})?$


# ^ = Start of the string.
# \d{5} = Match 5 digits (for condition 1, 2, 3)
# (?:…) = Grouping
# [-\s] = Match a space (for condition 3) or a hyphen (for condition 2)
# \d{4} = Match 4 digits (for condition 2, 3)
# …? = The pattern before it is optional (for condition 1)
# $ = End of the string.

# $ZIPREG=array(
#     "US"=>"^\d{5}([\-]?\d{4})?$",
#     "UK"=>"^(GIR|[A-Z]\d[A-Z\d]??|[A-Z]{2}\d[A-Z\d]??)[ ]??(\d[A-Z]{2})$",
#     "DE"=>"\b((?:0[1-46-9]\d{3})|(?:[1-357-9]\d{4})|(?:[4][0-24-9]\d{3})|(?:[6][013-9]\d{3}))\b",
#     "CA"=>"^([ABCEGHJKLMNPRSTVXY]\d[ABCEGHJKLMNPRSTVWXYZ])\ {0,1}(\d[ABCEGHJKLMNPRSTVWXYZ]\d)$",
#     "FR"=>"^(F-)?((2[A|B])|[0-9]{2})[0-9]{3}$",
#     "IT"=>"^(V-|I-)?[0-9]{5}$",
#     "AU"=>"^(0[289][0-9]{2})|([1345689][0-9]{3})|(2[0-8][0-9]{2})|(290[0-9])|(291[0-4])|(7[0-4][0-9]{2})|(7[8-9][0-9]{2})$",
#     "NL"=>"^[1-9][0-9]{3}\s?([a-zA-Z]{2})?$",
#     "ES"=>"^([1-9]{2}|[0-9][1-9]|[1-9][0-9])[0-9]{3}$",
#     "DK"=>"^([D-d][K-k])?( |-)?[1-9]{1}[0-9]{3}$",
#     "SE"=>"^(s-|S-){0,1}[0-9]{3}\s?[0-9]{2}$",
#     "BE"=>"^[1-9]{1}[0-9]{3}$",
#     "IN"=>"^\d{6}$"
# );