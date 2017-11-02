class RebaseIndexToUsers < ActiveRecord::Migration[5.0]
  def change
    add_index :users, :slack_user
    add_index :users, [:university_id, :student_no]
  end
end
