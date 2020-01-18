require 'httparty'
class MainPageController < ApplicationController
  include HTTParty      
  def display
    url = helpers.validate_me
    if url
      redirect_to url
    end
    @apps = helpers.request_api 'app/'
  end

  def callback
    @response = helpers.retrieve_token params["code"]
    redirect_to '/display'
  end
end
