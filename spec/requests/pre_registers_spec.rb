require 'rails_helper'

RSpec.describe "PreRegisters", type: :request do
  describe "GET /pre_registers" do
    it "works! (now write some real specs)" do
      get pre_registers_path
      expect(response).to have_http_status(401)
    end
  end
end
