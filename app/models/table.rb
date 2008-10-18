class Table < Base
  
  attr_reader :db_name
  
  def initialize name, db_name
    super name
    @db_name = db_name
  end
  
  def ar_class
    model_name = name.singularize.camelize
    c = nil
    begin
      c = model_name.constantize
    rescue
      c = Class.new ActiveRecord::Base
      Object.const_set model_name, c
      c.set_table_name name
    end
    c
  end
  
  def columns
    ActiveRecord::Base.connection.execute "use #{db_name}"
    ar_class.columns
  end
  
  
end
