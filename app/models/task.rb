class Task < ApplicationRecord
  belongs_to :organization
  has_many :applications, dependent: :destroy
end
