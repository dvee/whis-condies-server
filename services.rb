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
    uri = URI('https://www.whistlerblackcomb.com/the-mountain/mountain-conditions/snow-and-weather-report.aspx')
    response = Net::HTTP.get_response(uri)
    doc = Nokogiri::HTML(response.body)

    text_values = doc.css("div.live_temperature__temperature_display div.live_temperature__international_only").map(&:text)
    float_values = text_values.map { |s| s.match(/(-?\d+)\s?°C/)&.captures&.first&.to_f }
    float_values.delete(2) # pig alley temp

    @last_fetch = Time.now

    return ["peak", "mid", "valley"].zip(float_values).to_h.merge(
      {
        "last_updated" => @last_fetch
      }
    )
  end

end
