class Question
    attr_reader(:alternatives, :description)

    def initialize(alternatives, description)
        @alternatives = alternatives
        @description = description
    end
end
