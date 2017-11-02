class RemoveIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_index :users, :slack_user
    remove_index :users, [:university_id, :student_no]
  end
end
