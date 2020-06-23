class SchoolUnit < ApplicationRecord
    belongs_to :user, optional:true
end
