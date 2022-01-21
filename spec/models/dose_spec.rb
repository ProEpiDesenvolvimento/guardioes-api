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
end