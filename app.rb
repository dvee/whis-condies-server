require 'sinatra/base'
require 'sinatra/json'

class WhisCondiesApp < Sinatra::Base

  get "/health_check" do
    "OK"
  end

  get "/current-conditions" do
    "123"
  end

end