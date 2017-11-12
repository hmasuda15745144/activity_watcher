class ChangeStudentNoToUser < ActiveRecord::Migration[5.0]
  def up
    change_column :users, :student_no, :string, limit: 64, null: true
    change_column_default :users, :student_no, nil
  end
  
  def down
    change_column :users, :student_no, :string, limit: 64, null: false, default: ""
  end
end
