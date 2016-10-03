json.extract! team, :id, :name, :github_url, :web_url, :created_at, :updated_at
json.url team_url(team, format: :json)