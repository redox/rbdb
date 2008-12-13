# Monkey patch to avoid establishing a connection on application startup
module Rails
  class Initializer
    alias :initialize_database_original :initialize_database
    def initialize_database
    end
  end
end