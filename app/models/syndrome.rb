class Syndrome < ApplicationRecord
    has_one :message
    accepts_nested_attributes_for :message

    has_many :symptoms
end
