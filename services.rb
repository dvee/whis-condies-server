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

  end
end