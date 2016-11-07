module StubHelper
  def load_fixtures(path)
    File.read(File.dirname(__FILE__) + "/fixtures/groovehq/integration/#{path}.json")
  end
end