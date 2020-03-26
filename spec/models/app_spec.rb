require 'rails_helper'

RSpec.describe App, type: :model do
  # Validation tests
  # Ensures columns app_name and owner_country

  it {should validate_presence_of(:app_name) }
  it {should validate_presence_of(:owner_country) }
end