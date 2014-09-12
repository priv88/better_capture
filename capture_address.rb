require "rubygems"
require "nokogiri"
require "open-uri"
require "capybara"
require "httparty"
require "pp"
require 'pry-byebug'
require "timeout"
require "writeexcel"
require "csv"

class CaptureAddress
	
attr_accessor :session, :url

STATES = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennslyvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming", "Guam", "Puerto Rico", "Virgin Islands", "AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD", "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC", "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY", "GU", "PR", "VI"]

	def initialize(link_url)
		@session = Capybara::Session.new(:selenium)
		@url = link_url
	end

	def escape_advertisements
	end

	def make_angular_ready
		if @session.evaluate_script("window.angularReady === undefined") #variable is good to use
			#need to execute script to notify when angular finishes loading.
			@session.execute_script <<-JS
			window.angularReady = false; 
			var app = angular.element(document.querySelector('[ng-app]'));
			var injector = app.injector(); 
			injector.invoke(function($browser) {
			$browser.notifyWhenNoOutstandingRequests(function() {
			  window.angularReady = true;
			});
			});
			JS
		end 
		session.evaluate_script("window.angularReady")
	end

	def start_cache
 		@session.visit @url
	  	# make_angular_ready
	end

	def check_for_popups
		# @session.driver.browser.switch_to.alert.dismiss #dismiss js popups
		if @session.driver.browser.window_handles.count > 1 #close out any popups. 
			window_handles = @session.driver.browser.windows_handles
			@session.driver.browser.switch_to.window(windows_handles.last)
			@session.driver.browser.close
			@session.drive.browser.switch_to.windows(windows_handles.first)
		end
	end

	def check_for_zipcode
		regex = /^\d{5}(?:[-\s]\d{4})?$/
		@session.has_content?(regex)
	end

	def check_for_state
		status = false
		STATES.each do |state|
			status = true if @session.has_content?(', ' + state)
			break if status
		end
		status
	end

	def locate_text
		@session.all(:text => /^\d{5}(?:[-\s]\d{4})?$/)
	end

	def check_for_contact
		@session.has_link?(/contact/i)
	end


end