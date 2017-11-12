class AddAuthorityToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :authority, :integer, limit: 2, null: false, default: 1
  end
end
