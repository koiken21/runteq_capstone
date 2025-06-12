class Task < ApplicationRecord
  belongs_to :organization
  has_many :applications, dependent: :destroy

  STATUS_OPTIONS = [ "公開待ち", "募集中", "募集終了", "募集停止", "アーカイブ" ].freeze
end
