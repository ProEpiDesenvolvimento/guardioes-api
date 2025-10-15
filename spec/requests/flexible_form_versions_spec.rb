require 'rails_helper'

RSpec.describe "FlexibleFormVersions", type: :request do
  let(:app) { FactoryBot.create(:app) }
  let(:flexible_form) { FactoryBot.create(:flexible_form, app: app) }
  let!(:version1) { FactoryBot.create(:flexible_form_version, flexible_form: flexible_form, version: 1) }
  let!(:version2) { FactoryBot.create(:flexible_form_version, flexible_form: flexible_form, version: 2) }
  
  before do
    user = FactoryBot.create(:user)
    sign_in user
  end
  
  describe "GET /flexible_form_versions" do
    it "works! (now write some real specs)" do
      get flexible_form_versions_path
      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /flexible_form_versions/:id" do
    context "when form has multiple versions" do
      it "allows deletion of a version" do
        expect {
          delete flexible_form_version_path(version1)
        }.to change(FlexibleFormVersion, :count).by(-1)
        expect(response).to have_http_status(204)
      end
    end

    context "when trying to delete the last version" do
      it "prevents deletion and returns error" do
        version2.destroy
        
        expect {
          delete flexible_form_version_path(version1)
        }.not_to change(FlexibleFormVersion, :count)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['error']).to eq('Cannot delete the last version of a form')
      end
    end
  end
end
