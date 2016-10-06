class Member < ApplicationRecord
  validates :login, presence: true
end
