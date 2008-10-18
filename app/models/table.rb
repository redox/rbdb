class Table < Base
  
  attr_reader :db, :table_status
  
  def initialize name, db, table_status
    super name
    @db = db
    @table_status = table_status
  end
  
  def view?
    @table_status['Comment'] == 'VIEW'
  end
  
  def ar_class
    mod = db_module    
    model_name = name.singularize.camelize
    c = "#{mod}::#{model_name}".constantize
  rescue
    c = Class.new ActiveRecord::Base
    mod.const_set model_name, c
    c.set_table_name name
  ensure
    return c
  end
  
  def columns
    set_db
    # resolve foreign keys
    res = []
    ar_class.columns.each do |c|
      if c.name =~ /_id$/
        if t = @db.tables.detect {|t| t.name == c.name.gsub(/_id$/, '').pluralize}
          c = ForeignKey.new c, t
        end
      end
      res << c
    end
    return res
  end
  
  alias :old_method_missing :method_missing
  def method_missing(method, *args)
    return table_status[method.to_s] if table_status.has_key?(method.to_s)
    return old_method_missing(method, *args)
  end
  
  private
  def set_db
    ActiveRecord::Base.connection.execute "use #{@db.name}"
  end
  
  def db_module
    mod = db.name.camelize.constantize
  rescue
    mod = Module.new
    Object.const_set db.name.camelize, mod
  ensure
    return mod
  end
    
end
