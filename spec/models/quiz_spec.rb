require "rails_helper"

RSpec.describe Quiz do
    before do
        @question = Question.new(["Alternative 1", "Alternative 2"], "Some Question description")
    end
    it "Should Create a quiz with some question class" do
        quiz = Quiz.new(@question)
        expect(quiz.question).to be(@question)
    end
end