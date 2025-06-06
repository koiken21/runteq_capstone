class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.string :notification_type
      t.string :title
      t.text :body
      t.references :related_task, foreign_key: { to_table: :tasks }
      t.references :related_application, foreign_key: { to_table: :applications }
      t.boolean :is_read, default: false

      t.timestamps
    end
  end
end
