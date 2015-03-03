# Use this file to import the sales information into the
# the database.

require "pg"

def db_connection
  begin
    connection = PG.connect(dbname: "korning")
    yield(connection)
  ensure
    connection.close
  end
end
