class RenameConfirmedFlgToUsers < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :confirmed_flg, :registration_confirmed_flg
  end
end
