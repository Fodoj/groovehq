module GrooveHQ
  class Client

    def initialize(access_token = nil)
      @access_token = access_token || ENV["GROOVEHQ_ACCESS_TOKEN"]
    end

    def perform_request(path)
      url = "https://api.groovehq.com/v1/#{path}"

      response = HTTParty.get(url, headers: { 'Authorization' => "Bearer #{@access_token}" })

      JSON.parse(response.body)
    end
  end
end
