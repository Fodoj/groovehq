require "groovehq/client/connection"
require "groovehq/client/tickets"

module GrooveHQ
  class Client
    include HTTParty
    include GrooveHQ::Client::Connection
    include GrooveHQ::Client::Tickets

    base_uri "https://api.groovehq.com/v1"
    format :json

    def initialize(access_token = nil)
      access_token ||= ENV["GROOVEHQ_ACCESS_TOKEN"]
      self.class.default_options.merge!(headers: { 'Authorization' => "Bearer #{access_token}" })
    end

  end
end
