require 'webmock/rspec'
require_relative '../lib/groovehq'

RSpec.configure do |config|

  config.before :all, integration: true do
    WebMock.disable!
  end

end
