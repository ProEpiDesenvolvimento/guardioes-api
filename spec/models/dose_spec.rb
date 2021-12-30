require 'rails_helper'

RSpec.describe Dose, type: :model do

  before :all do
    App.new(:app_name=>"brasil", :owner_country=>"brasil").save()
    User.new(
       :user_name => "Noel",
       :email => "123456@gmail.com",
       :password => "testeteste",
       :app_id => 1
      ).save()
    Vaccine.new(
      :id=> 1,
      :app_id=> 1,
      :name=> "Vacina 1" ,
      :laboratory=>"o lab",
      :country_origin=> "brasil",
      :min_dose_interval=>20,
      :max_dose_interval=>40,
      :doses=>5
      ).save()
    end


  context 'check date' do
    it 'when date format is passed correctly' do
      dose = Dose.new(:date=>'2021-12-09', :dose=>2, :vaccine_id=> 1, :user_id=> 1)
      expect(dose).to be_valid
    end

    it 'when date format is passed wrong' do
      dose = Dose.new(date:'2021-0', dose: 2, vaccine_id: 1, user_id: 1)
      expect(dose).to_not be_valid
    end

    it 'the field cannot be null' do
      dose = Dose.new(date: nil, dose: 2, vaccine_id: 1, user_id: 1)
      expect(dose).to_not be_valid
    end

  end

  context 'check dose' do
    it 'when dose format is passed correctly' do
      dose = Dose.new(date: '2021-12-09', dose: 2, vaccine_id: 1, user_id: 1)
      expect(dose).to be_valid
    end

    it 'when dose format is passed wrong' do
      dose = Dose.new(date: '2021-12-09', dose: 'segunda', vaccine_id: 1, user_id: 1)
      expect(dose).to_not be_valid
    end

    it 'the field cannot be null' do
      dose = Dose.new(date: '2021-12-09', dose: nil, vaccine_id: 1, user_id: 1)
      expect(dose).to_not be_valid
    end
    
  end

end
