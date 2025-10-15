require 'rails_helper'

RSpec.describe "FlexibleForms", type: :request do
  let(:app) { FactoryBot.create(:app) }
  let(:user) { FactoryBot.create(:user, app: app) }
  
  before do
    sign_in user
  end
  
  describe "GET /flexible_forms" do
    it "works! (now write some real specs)" do
      get flexible_forms_path
      expect(response).to have_http_status(200)
    end
  end

  describe "GET /flexible_forms/quizzes" do
    context "when there are forms with versions" do
      let!(:flexible_form_with_version) do
        form = FactoryBot.create(:flexible_form, form_type: "quiz", app: app)
        FactoryBot.create(:flexible_form_version, flexible_form: form)
        form
      end

      it "returns forms that have at least one version" do
        get quizzes_flexible_forms_path
        expect(response).to have_http_status(200)
        json_response = JSON.parse(response.body)
        expect(json_response).to be_an(Array)
      end
    end
  end
end
