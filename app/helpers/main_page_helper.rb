module MainPageHelper
    @@client_id = ENV["CLIENT_ID"]
    @@redirect_uri=ENV["REDIRECT_URI"]
    @@scope=ENV["SCOPE"]
    @@client_secret=ENV["CLIENT_SECRET"]
    def validate_me
        if session[:expired]==nil
            url= "https://podio.com/oauth/authorize?client_id=#{@@client_id}&redirect_uri=#{@@redirect_uri}&scope=#{@@scope}"
            return url
        elsif session[:expired].to_i < Time.now.getutc.to_i
            refresh_token
            return false
        end
    end
    
    def refresh_token
        response = HTTParty.post("https://podio.com/oauth/token?grant_type=refresh_token&client_id=#{@@client_id}&redirect_uri=#{@@redirect_uri}&client_secret=#{@@client_secret}&refresh_token=#{session[:refresh_token]}")
        session[:access_token] = response["access_token"]
        session[:expired] = (Time.now + response["expires_in"].to_i).getutc.to_i
        session[:refresh_token] = response["refresh_token"]
    end

    def retrieve_token(code)
        response = HTTParty.post("https://podio.com/oauth/token?grant_type=authorization_code&client_id=#{@@client_id}&redirect_uri=#{@@redirect_uri}&client_secret=#{@@client_secret}&code=#{code}")
        session[:access_token] = response['access_token']
        session[:expired] = (Time.now + response["expires_in"].to_i).getutc.to_i
        session[:refresh_token] = response["refresh_token"]
        response['access_token']
    end

    def request_api(path)
        headers = {:Authorization => "Bearer #{session[:access_token]}","Content-Type"=>"application/json"}
        response = HTTParty.get("https://api.podio.com/#{path}",:headers=>headers)
    end
end
