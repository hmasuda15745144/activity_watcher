class CreateUniversities < ActiveRecord::Migration[5.0]
  def change
    create_table :universities do |t|
      t.string :name, limit: 64, null: false, default: ""
      t.string :name_en, limit: 128, null: false, default: ""
      t.string :description, limit: 256

      t.timestamps
    end
  end
end
