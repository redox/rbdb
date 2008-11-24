class Base
  
  attr_reader :name
  attr_writer :new_record
  
  def initialize name = nil
    @name = name
  end
  
  def to_param
    name
  end
  
  alias :id :name

  def self.execute sql
    connection.execute sql
  end
  
  def self.connection
    ActiveRecord::Base.connection
  end
  
  def new_record?
    @name.nil? or @new_record
  end

  def self.sanitize_table(name)
    connection.quote_table_name(name)
  end
  
  def sanitize_table name
    self.class.sanitize_table name
  end
  
end
