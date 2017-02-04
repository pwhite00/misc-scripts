require 'sqlite3'

dbs = {:database => 'foo.db'}

db = SQLite3::Database.new(dbs[:database])
db.execute("CREATE TABLE cuts (value Integer, timestamp TEXT, comment TEXT);")
puts File.exists?('foo.db')
puts db.execute('schema')
