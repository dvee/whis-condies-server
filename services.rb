require 'net/http'
require 'nokogiri'

class ConditionsGetter

  CACHE_EXPIRY = 10 * 60 # 10 minutes

  def initialize
    @cache = nil
    @last_fetch = nil
  end

  # return current conditions from cache
  #
  def call
    if @cache.nil? || Time.now - @last_fetch > CACHE_EXPIRY
      @cache = fetch_conditions
    end
    @cache
  end

  def fetch_conditions
    uri = URI('https://m.whistlerblackcomb.com/m/app-temps-2016.php')
    response = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML(response.body)

    div_classes = ["peak", "rhl", "village"]

    temps = div_classes.map do |c|
      s = doc.css("div.#{c} h4").text
      s.match(/(-?\d+\.\d+)°C/)&.captures&.first&.to_f
    end

    @last_fetch = Time.now

    return ["peak", "mid", "valley"].zip(temps).to_h.merge(
      {
        "last_updated" => @last_fetch
      }
    )
  end

end