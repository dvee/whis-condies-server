require 'sinatra/base'
require 'sinatra/json'
require_relative 'services'

class WhisCondiesApp < Sinatra::Base

  set :protection, :except => :json_csrf

  configure do
    @@conditions_getter = ConditionsGetter.new
  end

  get "/health_check" do
    "OK"
  end

  get "/current-conditions" do
    json @@conditions_getter.call
  end

end