class AddConfirmedFlgToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :confirmed_flg, :boolean, default: false
  end
end
