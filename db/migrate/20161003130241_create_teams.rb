class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :github_url
      t.string :web_url

      t.timestamps
    end
  end
end
