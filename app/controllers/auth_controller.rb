class AuthController < ApplicationController

  require "pp"

  def callback
	require 'net/http'
	require 'json'
	require 'uri'

  	code = params["code"]

	uri = URI.parse("https://#{ENV['SALESFORCE_HOST']}/services/oauth2/token") 
	param = "client_id=#{ENV['SALESFORCE_CONSUMER_KEY']}&client_secret=#{ENV['SALESFORCE_CONSUMER_SECRET']}&redirect_uri=#{ENV['SALESFORCE_REDIRECT_URI']}&grant_type=authorization_code&code=#{code}"
	
	https = Net::HTTP.new(uri.host, 443)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_PEER  
	res = https.post(
	    uri.request_uri, param
	)
	response = JSON.parse(res.body)

	pp response

	#pp response
	access_token = response["access_token"]
	payload = response["id_token"].split(".")[1]
	payload = Base64.decode64( payload );
	payload = JSON.parse( payload );
	pp payload




	# get userinfo


	url = "https://#{ENV['SALESFORCE_HOST']}/services/oauth2/userinfo"
	uri = Addressable::URI.parse(url) 
	https = Net::HTTP.new(uri.host, 443)
	https.use_ssl = true
	https.verify_mode = OpenSSL::SSL::VERIFY_PEER  
	req = Net::HTTP::Get.new(uri.request_uri)
	req["Authorization"] = "Bearer "+access_token
	res = https.request(req)
	response = JSON.parse(res.body)
	pp response
	session[:user] = response["name"]
	redirect_to login_path

  end


  def initiate
  	url = "https://#{ENV['SALESFORCE_HOST']}/services/oauth2/authorize?response_type=code&client_id=#{ENV['SALESFORCE_CONSUMER_KEY']}&redirect_uri=#{ENV['SALESFORCE_REDIRECT_URI']}"
	redirect_to url
  end

end
