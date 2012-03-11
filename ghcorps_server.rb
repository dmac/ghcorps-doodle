require "oauth"
require "nokogiri"
require "./models/user"
require "./models/poll"

class GHCorps < Sinatra::Base
  get "/" do
    redirect request_token.authorize_url unless access_token
    user = User.get_user(access_token)
    erb :index, :locals => { :polls => user.polls }
  end

  get "/oauth/callback" do
    make_access_token(params[:oauth_verifier])
    redirect "/"
  end

  def consumer
    @@consumer ||= OAuth::Consumer.new("nur1oamwpszmvkaal7fmrh2vnlqkj8pw", "24nfmsyeh8shl7mo1z5iku7vj5uzqn2b",
      { :site => "http://doodle.com", :request_token_path => "/api1/oauth/requesttoken",
        :access_token_path => "/api1/oauth/accesstoken", :authorize_path => "/api1/oauth/authorizeConsumer" })
  end

  def request_token()
    @@request_token ||= consumer.get_request_token(
        { :oauth_callback => "http://127.0.0.1:8000/oauth/callback" },
        { "doodle_get" => "name|initiatedPolls"} )
  end

  def make_access_token(oauth_verifier)
    @@access_token ||= request_token.get_access_token(:oauth_verifier => oauth_verifier)
  end

  def access_token() @@access_token ||= nil end
end
