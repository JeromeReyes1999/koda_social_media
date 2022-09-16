class IpGeoLocationService
  attr_reader :url, :key
  def initialize
    @url = "https://api.ipgeolocation.io/ipgeo"
    @key = Rails.application.config_for(:settings)[:merchant][:ip_geolocation][:key]
  end

  def get_location(ip)
    response = RestClient.get url, {params: {apiKey: key, ip: ip}}
    JSON.parse(response.body)
  end
end