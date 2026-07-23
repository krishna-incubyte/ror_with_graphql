class CurrencyExchangeRateFetcher
  SUCCESS_CODE = 'success'
  ERROR_CODE = 'error'
  BASE_URL = 'https://v6.exchangerate-api.com/v6'

  def self.execute(source:, target:, requester: HttpRequester)
    url = self.construct_url(source: source, target: target)
    response = requester.new(url: url).make_get_request

    result = response['result']
    if result == SUCCESS_CODE
      response["conversion_rate"]
    elsif result == ERROR_CODE
      response["error-type"]
    end
  end

  def self.construct_url(source: , target: )
    api_key = Rails.application.credentials.exchange_rate.api_key

    url = "#{BASE_URL}/#{api_key}/pair/#{source}/#{target}"
  end
end