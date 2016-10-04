class RenameGithubUrlAndWebUrlToTeams < ActiveRecord::Migration[5.0]
  def change
    rename_column :teams, :github_url, :source
    rename_column :teams, :web_url, :service
  end
end
