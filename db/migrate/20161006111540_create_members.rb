class CreateMembers < ActiveRecord::Migration[5.0]
  def change
    create_table :members do |t|
      t.string :login
      t.string :name
      t.string :idno

      t.timestamps
    end
  end
end
