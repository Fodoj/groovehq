require 'spec_helper'

describe GrooveHQ::Client::Groups, integration: true do

  let(:client) { GrooveHQ::Client.new }

  describe "#groups" do

    let(:response) { client.groups }

    it "successfully gets groups" do
      expect(response).to be_instance_of GrooveHQ::ResourceCollection
    end

  end

end
