require 'rails_helper'

RSpec.describe Average, type: :model do
  context "Create and read average grade" do
    it "should create an average from a list of numbers" do
      numbers = [4, 7, 7, 10]
      average = Average.new
      result = average.createAverage(numbers)
      expect(result).to eq(7)
    end

    it "should read the average of an object" do
      numbers = [4, 10, 7, 10]
      average = Average.new
      average.createAverage(numbers)
      result = average.readAverage()
      expect(result).to eq(7.75)
    end
  end
end 
