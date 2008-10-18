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
    
end
