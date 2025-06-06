class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks do |t|
      t.string :title
      t.text :description
      t.date :apply_deadline
      t.integer :required_number_of_people
      t.string :status
      t.references :organization, null: false, foreign_key: true

      t.timestamps
    end
  end
end
