require 'spec_helper'

describe GrooveHQ::Client::Folders, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#folders" do

    let(:response) { client.folders }

    it "successfully gets folders" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

  end

end
