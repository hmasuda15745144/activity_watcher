table_names = %w( universities )

table_names_join = table_names.join(",")
ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_names_join} RESTART IDENTITY CASCADE;")

table_names.each do |table_name|
  path = Rails.root.join('db', 'seeds', "#{table_name}.rb")
  if File.exist?(path)
    puts "Creating #{table_name}...."
    require(path)
  end
end