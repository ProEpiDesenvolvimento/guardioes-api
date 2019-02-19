class App < ApplicationRecord
    has_many :admins
    has_many :users
    has_many :symptoms
    has_many :public_hospitals
    has_many :contents
end
