# Monkey patch to avoid establishing a connection on application startup
module Rails
  class Initializer
    alias :initialize_database_original :initialize_database
    def initialize_database
    end
  end
end

module ActiveRecord
  class Base
    class << self
      def instantiate(record)
        object = allocate
        object.instance_variable_set("@attributes", record)
        object.instance_variable_set("@attributes_cache", Hash.new)
        object.send(:callback, :after_find) if object.respond_to_without_attributes?(:after_find)  
        object.send(:callback, :after_initialize) if object.respond_to_without_attributes?(:after_initialize)
        object
      end
    end
  end
end