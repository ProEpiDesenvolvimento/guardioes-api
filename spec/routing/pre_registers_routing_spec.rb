require "rails_helper"

RSpec.describe PreRegistersController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/pre_registers").to route_to("pre_registers#index")
    end

    it "routes to #show" do
      expect(:get => "/pre_registers/1").to route_to("pre_registers#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/pre_registers").to route_to("pre_registers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/pre_registers/1").to route_to("pre_registers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/pre_registers/1").to route_to("pre_registers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/pre_registers/1").to route_to("pre_registers#destroy", :id => "1")
    end
  end
end
