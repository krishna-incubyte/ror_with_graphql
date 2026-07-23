class HttpRequester

  def initialize(url: )
    @url = url
  end

  def make_get_request
    uri = URI(@url)
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end
end