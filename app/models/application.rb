class Application < ApplicationRecord
  belongs_to :task
  belongs_to :supporter, class_name: "User"
end
