require 'rails_helper'

RSpec.describe Dose, type: :model do
  describe 'check date' do 
    context 'when date format is passed correctly' do 
      it 'when the parameters are right' do
        dose = build(:dose)
				expect(dose).to be_valid
      end
    end
  end

	describe 'relationships' do
		context 'when Model Dose does not belongs to Model Vaccine' do
      it { expect(build(:dose, vaccine_id: nil)).to be_invalid }
    end
    context 'when Model Dose does not belongs to Model User' do
      it { expect(build(:dose, user_id: nil)).to be_invalid }
    end
	end

	describe 'validations' do
		context 'when date format is passed wrong' do
      it { expect(build(:dose, date: '2021-0')).to be_invalid }
    end

		context 'when the field date is nil' do
      it { expect(build(:dose, date: nil)).to be_invalid }
    end

    context 'when dose format is passed wrong' do
      it { expect(build(:dose, dose: 'segunda')).to be_invalid }
    end

		context 'when the field dose is nil' do
      it { expect(build(:dose, dose: nil)).to be_invalid }
    end
	end

  describe 'methods' do
		context 'when migrating both doses' do
      vaccine_test = Vaccine.create(
        id: 1,
        app: App.all.first,
        name: 'VacinaTeste', 
        laboratory: 'LaboratorioTeste',
        doses: 2,
        disease: 'Covid',
        country_origin: 'Brazil',
        min_dose_interval: 15,
        max_dose_interval: 30
      )

      test_user = User.create(
        id:1,
        user_name: 'Guilherme',
        email: 'guilherme@email.com',
        password: "12345678",
        birthdate: '1994-12-14',
        country: 'Brazil',
        gender: 'Homem Cis',
        race: "human",
        first_dose_date: '2010-08-05',
        second_dose_date: '2010-08-15',
        is_professional: false,
        app: App.all.first,
        vaccine: vaccine_test
      )

      Dose.migrate_doses

      search_dose_1 = Dose.where(user_id:test_user.id, dose:1).first
      search_dose_2 = Dose.where(user_id:test_user.id, dose:2).first

      it { expect(search_dose_1.present?).to be(true) }
      it { expect(search_dose_2.present?).to be(true) }
    
    end

    context 'when migrating and second dose date missing' do
      vaccine_test = Vaccine.create(
        id: 2,
        app: App.all.first,
        name: 'VacinaTeste', 
        laboratory: 'LaboratorioTeste',
        doses: 2,
        disease: 'Covid',
        country_origin: 'Brazil',
        min_dose_interval: 15,
        max_dose_interval: 30
      )

      test_user = User.create(
        id:2,
        user_name: 'Guilherme',
        email: 'guilherme2@email.com',
        password: "12345678",
        birthdate: '1994-12-14',
        country: 'Brazil',
        gender: 'Homem Cis',
        race: "human",
        first_dose_date: '2010-08-05',
        is_professional: false,
        app: App.all.first,
        vaccine: vaccine_test
      )

      Dose.migrate_doses

      search_dose_1 = Dose.where(user_id:test_user.id, dose:1).first
      search_dose_2 = Dose.where(user_id:test_user.id, dose:2).first

      it { expect(search_dose_1.present?).to be(true) }
      it { expect(search_dose_2.present?).to be(false) }
    
    end

    context 'when migrating doses and first dose date missing' do
      vaccine_test = Vaccine.create(
        id: 3,
        app: App.all.first,
        name: 'VacinaTeste', 
        laboratory: 'LaboratorioTeste',
        doses: 2,
        disease: 'Covid',
        country_origin: 'Brazil',
        min_dose_interval: 15,
        max_dose_interval: 30
      )

      test_user = User.create(
        id:3,
        user_name: 'Guilherme',
        email: 'guilherme3@email.com',
        password: "12345678",
        birthdate: '1994-12-14',
        country: 'Brazil',
        gender: 'Homem Cis',
        race: "human",
        second_dose_date: '2010-08-05',
        is_professional: false,
        app: App.all.first,
        vaccine: vaccine_test
      )

      Dose.migrate_doses

      search_dose_1 = Dose.where(user_id:test_user.id, dose:1).first
      search_dose_2 = Dose.where(user_id:test_user.id, dose:2).first

      it { expect(search_dose_1.present?).to be(false) }
      it { expect(search_dose_2.present?).to be(true) }
    
    end
	end
end