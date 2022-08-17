require 'rails_helper'

RSpec.describe RegistrationController, :type => :controller do
    subject(:create_admin) {described_class.new(sign_up_params)}
    subject(:create_admin) {described_class.new(current_admin)}
    subject(:create_admin) {described_class.new(params[:admin])}
    describe 'POST #create' do
        context 'Para entradas válidas' do
        let (:sign_up_params) { Admin.new(:first_name => "Joao",
                                     :last_name => "Martins",
                                     :email => "joao@gmail.com",
                                     :app_id => 1
                                    )
                                }

        let (:current_admin) { Admin.new(:first_name => "Maria ",
                                     :last_name => "Martins",
                                     :email => "maria@gmail.com",
                                     :app_id => 2,
                                     :is_god =>true
                                    )
                                }     
        let (:params) { Admin.new(:first_name => "Miguel",
                                     :last_name => "Marques",
                                     :email => "Miguel@gmail.com",
                                     :app_id => 3,
                                     :is_god =>false
                                    )
                                }                      
                                
        it "current.is_god == true and params.is_god == true => sign_up_params != nil" do
        
        expect(current_admin.is_god).to eq(true)
        expect(params.is_god).to eq(true)
        expect(sign_up_params).to_not eq(nil)
        end
        end       
    end
end

RSpec.describe RegistrationController, :type => :controller do
    subject(:create_admin) {described_class.new(sign_up_params)}
    subject(:create_admin) {described_class.new(current_admin)}
    subject(:create_admin) {described_class.new(params[:admin])}
    describe 'POST #create' do
        context 'Para entradas válidas 2' do
        let (:sign_up_params) { Admin.new(:first_name => "Eduarda",
                                     :last_name => "Mendes",
                                     :email => "duda@gmail.com",
                                     :app_id => 6
                                    )
                                }

        let (:current_admin) { Admin.new(:first_name => "Roberta",
                                     :last_name => "Cavalcante",
                                     :email => "roberta@gmail.com",
                                     :app_id => 7,
                                     :is_god =>false
                                    )
                                }     
        let (:params) { Admin.new(:first_name => "Miguel",
                                     :last_name => "Marques",
                                     :email => "Miguel@gmail.com",
                                     :app_id => 8,
                                     :is_god =>false
                                    )
                                }                      
                                
        it "current.is_god == false and params.is_god == false => sign_up_params != nil" do
        
        expect(current_admin.is_god).to eq(false)
        expect(params.is_god).to eq(false)
        expect(sign_up_params).to_not eq(nil)
        end
        end       
    end
end

RSpec.describe RegistrationController, :type => :controller do
    subject(:create_admin) {described_class.new(sign_up_params)}
    subject(:create_admin) { described_class.new(current_admin)}
    subject(:create_admin) { described_class.new(params[:admin])}
    describe 'POST #create' do
        context 'Para entradas válidas 3' do
        let (:sign_up_params) { Admin.new(:first_name => "Joao Pedro",
                                     :last_name => "Oliveira",
                                     :email => "joaopedro@gemail.com",
                                     :app_id => 9
                                    )
                                }

        let (:current_admin) { Admin.new(:first_name => "Maria",
                                     :last_name => "Queiroz",
                                     :email => "maria@gmail.com",
                                     :app_id => 10,
                                     :is_god =>true
                                    )
                                }     
        let (:params) { Admin.new(:first_name => "Miguel",
                                     :last_name => "Marques",
                                     :email => "Miguel@gmail.com",
                                     :app_id => 11,
                                     :is_god =>false
                                    )
                                }                      
                                
        it "current.is_god == true and params.is_god == false => sign_up_params != nil" do
        
        expect(current_admin.is_god).to eq(true)
        expect(params.is_god).to eq(false)
        expect(sign_up_params).to_not eq(nil)
        end
        end       
    end
end

RSpec.describe RegistrationController, :type => :controller do
    subject(:create_admin) {described_class.new(sign_up_params)}
    subject(:create_admin) {described_class.new(current_admin)}
    subject(:create_admin) {described_class.new(params[:admin])}
    describe 'POST #create' do
        context 'Para entradas válidas 4' do
        let (:sign_up_params) {  }
        let (:current_admin) { Admin.new(:first_name => "Victor",
                                     :last_name => "Aires",
                                     :email => "victor@gmail.com",
                                     :app_id => 4,
                                     :is_god =>false
                                    )
                                }     
        let (:params) { Admin.new(:first_name => "Miguel",
                                     :last_name => "Marques",
                                     :email => "Miguel@gmail.com",
                                     :app_id => 5,
                                     :is_god =>false
                                    )
                                }                       
                                
        it "current.is_god == false and params.is_god == true => sign_up_params == nil" do
        
        expect(current_admin.is_god).to eq(false)
        expect(params.is_god).to eq(true)
        expect(sign_up_params).to eq(nil)
        end
        end       
    end
end