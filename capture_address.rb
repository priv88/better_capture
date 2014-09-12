require "rubygems"
require "nokogiri"
require "open-uri"
require "capybara"
require "capybara-webkit"
require "httparty"
require "pp"
require 'pry-byebug'
require "timeout"
require "writeexcel"
require "csv"

class CaptureAddress
	
attr_accessor :session, :url, :state, :status

STATES = ["CA", "California", "NY", "New York", "CT", "Connecticut", "TX", "Texas", "UT", "Utah", "MA", "Massachusetts", "VA", "Virginia", "WA", "Washington", "IL", "Illinois", "FL", "Florida", "PA", "Pennslyvania", "NJ", "New Jersey", "MD", "Maryland", "CO", "Colorado", "DE", "Delaware", "MI", "Michigan", "RI", "Rhode Island", "AZ", "Arizona", "AL", "AK",  "AR", "GA", "HI", "ID", "IN", "IA", "KS", "KY", "LA", "ME", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NM",  "NC", "ND", "OH", "OK", "OR", "SC", "SD", "TN", "VT", "WV", "WI", "WY", "GU", "PR", "VI", "Alabama", "Alaska", "Arkansas",  "Georgia", "Hawaii", "Idaho", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Mexico", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon",  "South Carolina", "South Dakota", "Tennessee", "Vermont", "West Virginia", "Wisconsin", "Wyoming", "Guam", "Puerto Rico", "Virgin Islands"]

	def initialize(link_url)
		@session = Capybara::Session.new(:selenium)
		@url = link_url
		@state = nil
		@status = false
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
		@status = true if @session.has_content?(regex)
	end

	def check_for_state
		STATES.each do |state|
			if @session.has_content?(', ' + state)
				@status = true
				@state = state
			end
			break if @status
		end
		puts @state
	end

	def locate_text
		@session.all(:text => /^\d{5}(?:[-\s]\d{4})?$/)
	end

	def locate_state
		
		# @session.all(:xpath, '//p[text()=@state]')
		# @session.all(:xpath, '//div[text()=@state]')
		@session.all('span', :text => "#{@state}")
	end

	def check_for_contact
		@session.has_link?(/contact/i)
	end

    
end