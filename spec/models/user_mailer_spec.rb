require 'rails_helper'
require 'spec_helper'

RSpec.describe UserMailer, type: :mailers do

  before :all do
    App.new(:app_name=>"brasil", :owner_country=>"brasil").save()
  end

  let (:valid_user) {
    User.new(
      :user_name => "teste",
      :email => "teste@teste.com",
      :password => "12369420",
      :app_id => 1
    )
  }

  it "succes, reset password" do
    user = valid_user
    response = UserMailer.reset_password_email(user)
    expect(response.subject).to eq("[Guardiões da Saúde] Redefinir Senha")
  end

  it "failed, reset password for user_name nil" do
    user = valid_user
    user.user_name = nil
    response = UserMailer.reset_password_email(user)
    expect(response.subject).to eq("Usuário inválido")
  end

  it "failed, reset password for user_email nil" do
    user = valid_user
    user.email = nil
    response = UserMailer.reset_password_email(user)
    expect(response.subject).to eq("Usuário inválido")
  end

  it "failed, reset password for user nil" do
    response = UserMailer.reset_password_email(nil)
    expect(response.subject).to eq("Campo inválido, informe um usuário")
  end
end