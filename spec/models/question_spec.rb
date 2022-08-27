require "rails_helper"

RSpec.describe Question do
    it "Should be possible to create one alternative for a question" do
        question = Question.new(["First alternative"], "Some Question")
        expect(question.alternatives).to eq(["First alternative"])
        expect(question.description).to eq("Some Question")
    end

    it "Should be possible to create More alternatives" do
        question = Question.new(["First alternative", "Second Alternative"], "Some Question")
        expect(question.alternatives).to eq(["First alternative", "Second Alternative"])
        expect(question.description).to eq("Some Question")
    end
end