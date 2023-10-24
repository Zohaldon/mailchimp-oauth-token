# frozen_string_literal: true

require 'MailchimpMarketing'
require 'net/http'
require 'sinatra'

require_relative 'environment'

MAILCHIMP_CLIENT_ID = ENV['MAILCHIMP_CLIENT_ID']
MAILCHIMP_CLIENT_SECRET = ENV['MAILCHIMP_CLIENT_SECRET']
BASE_URL = ENV['MAILCHIMP_BASE_URL']
OAUTH_CALLBACK = "#{BASE_URL}/oauth/mailchimp/callback"

mailchimp = MailchimpMarketing::Client.new

# Basic Sinatra setup
configure do
  set :port, 4455
end

# 1. Navigate to http://127.0.0.1:3000 and click Login
get '/' do
  "<p>Welcome to the sample Mailchimp OAuth app! Click <a href='/auth/mailchimp'>here</a> to log in</p>"
end

# 2. The login link above will direct the user here, which will redirect
#    to Mailchimp's OAuth login page
get '/auth/mailchimp' do
  query_params = "response_type=code&client_id=#{MAILCHIMP_CLIENT_ID}&redirect_uri=#{OAUTH_CALLBACK}"
  redirect to("https://login.mailchimp.com/oauth2/authorize?#{query_params}")
end

# 3. Once the user authorizes your app, Mailchimp will redirect the user to
#    this endpoint, along with a code you can use to exchange for the user's
#    access token.
get '/oauth/mailchimp/callback' do
  code = params['code']
  body = "grant_type=authorization_code&client_id=#{MAILCHIMP_CLIENT_ID}&client_secret=#{MAILCHIMP_CLIENT_SECRET}&redirect_uri=#{OAUTH_CALLBACK}&code=#{code}"
  uri = URI('https://login.mailchimp.com/oauth2/token')
  response = JSON.parse(Net::HTTP.post(uri, body).body)
  puts response
  access_token = response['access_token']

  metadata_uri = URI('https://login.mailchimp.com/oauth2/metadata')
  metadata_response = JSON.parse(
    Net::HTTP.post(
      metadata_uri,
      nil,
      { 'Authorization' => "OAuth #{access_token}" }
    ).body
  )
  dc = metadata_response['dc']

  mailchimp.set_config({
                         access_token: access_token,
                         server: dc
                       })

  mailchimp_res = mailchimp.ping.get

  """
    <p>This user's access token is <code>#{access_token}</code> and their server prefix is #{dc}.</p>

    <p>When pinging the Mailchimp Marketing API's ping endpoint, the server responded:<p>

    <code>#{mailchimp_res}</code>
  """
end
