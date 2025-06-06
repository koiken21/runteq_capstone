class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :related_task
  belongs_to :related_application
end
