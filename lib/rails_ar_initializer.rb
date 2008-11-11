# Monkey patch to avoid establishing a connection on application startup
module Rails
  class Initializer
    def initialize_database ; end
  end
end