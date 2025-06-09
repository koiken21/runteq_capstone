class AddUserRegistrationFields < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :password_digest, :string
    add_column :users, :registration_token, :string
    add_column :users, :registration_token_sent_at, :datetime
    change_column :users, :role, :integer, using: 'role::integer'
    add_index :users, :registration_token, unique: true
  end
end
