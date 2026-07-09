class CurrencyExchangeRateFetcher
  SUCCESS_CODE = 'success'
  ERROR_CODE = 'error'
  BASE_URL = 'https://v6.exchangerate-api.com/v6'

  def self.execute(source:, target:)
    api_key = Rails.application.credentials.exchange_rate.api_key

    url = "#{BASE_URL}/#{api_key}/pair/#{source}/#{target}"
    uri = URI(url)
    response = Net::HTTP.get(uri)
    parsed_response = JSON.parse(response)
    result = parsed_response['result']
    if result == SUCCESS_CODE
      parsed_response["conversion_rate"]
    elsif result == ERROR_CODE
      parsed_response["error-type"]
    end
  end
end