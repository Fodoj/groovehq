require 'webmock/rspec'
require_relative '../lib/groovehq'

RSpec.configure do |config|
  config.before(:all) do
    if self.class.metadata[:integration] == true
      WebMock.disable!
    else
      WebMock.enable!
    end
  end
end
