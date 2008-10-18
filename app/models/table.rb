class Table < Base
  
  attr_reader :db
  
  def initialize name, db, view
    super name
    @db = db
    @view = view == 'VIEW'
  end
  
  def view?
    @view
  end
  
  def engine
    return @engine if @engine
    return @engine = '' if view?
    set_db
    ActiveRecord::Base.connection.execute("show create table #{name}").fetch_row.to_s =~ /ENGINE=(\S+)/
    @engine = $1
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
