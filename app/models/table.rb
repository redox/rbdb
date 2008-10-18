class Table < Base
  
  attr_reader :db
  
  def initialize name, db
    super name
    @db = db
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
    ActiveRecord::Base.connection.execute "use #{@db.name}"
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
    
end
