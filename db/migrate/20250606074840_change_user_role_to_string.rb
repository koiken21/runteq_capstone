class ChangeUserRoleToString < ActiveRecord::Migration[8.0]
  def up
    change_column :users, :role, :string, using: 'role::text'
  end

  def down
    change_column :users, :role, :integer, using: 'role::integer'
  end
end
