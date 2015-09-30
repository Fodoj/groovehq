require "groovehq/client/connection"

require "groovehq/client/agents"
require "groovehq/client/customers"
require "groovehq/client/folders"
require "groovehq/client/groups"
require "groovehq/client/mailboxes"
require "groovehq/client/attachments"
require "groovehq/client/messages"
require "groovehq/client/tickets"
require "groovehq/client/webhooks"

module GrooveHQ
  class Client
    include HTTParty
    include GrooveHQ::Client::Connection
    include GrooveHQ::Client::Agents
    include GrooveHQ::Client::Customers
    include GrooveHQ::Client::Folders
    include GrooveHQ::Client::Groups
    include GrooveHQ::Client::Mailboxes
    include GrooveHQ::Client::Attachments
    include GrooveHQ::Client::Messages
    include GrooveHQ::Client::Tickets
    include GrooveHQ::Client::Webhooks

    base_uri "https://api.groovehq.com/v1"
    format :json

    def initialize(access_token = nil)
      access_token ||= ENV["GROOVEHQ_ACCESS_TOKEN"]
      self.class.default_options.merge!(headers: { 'Authorization' => "Bearer #{access_token}" })
    end

  end
end
