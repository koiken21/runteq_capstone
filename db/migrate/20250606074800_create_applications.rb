class CreateApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :applications do |t|
      t.references :task, null: false, foreign_key: true
      t.references :supporter, null: false, foreign_key: { to_table: :users }
      t.string :application_status
      t.string :request_status
      t.text :comment_supporter
      t.text :comment_organization
      t.text :experience
      t.string :uptime

      t.timestamps
    end
  end
end
