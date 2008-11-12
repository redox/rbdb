class Table < Base
  
  attr_reader :db, :table_status
  
  def initialize name, db, table_status = nil
    super name
    @db = db
    @table_status = table_status
  end
  
  def self.create!(params, db, prim = nil)
    ActiveRecord::Base.connection.create_table params[:name], :id => false, :primary => prim do |t|
      params[:fields].each do |f|
        t.column f[:name], f[:type], f[:options]
      end
    end
  end
  
  def view?
    @table_status['comment'] == 'VIEW'
  end
  
  def ar_class
    mod = db_module
    model_name = name.singularize.camelize
    c = "#{mod}::#{model_name}".constantize
  rescue NameError
    c = create_custom_ar_class
    c = mod.const_set model_name, c
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
  
  def indexes
    return @indexes if @indexes
    current_index = nil
    Base.execute("SHOW KEYS FROM #{sanitize_table name}").each do |row|
      @indexes ||= []
      if current_index != row[2]
        current_index = row[2]
        # | Table     | Non_unique | Key_name | Seq_in_index | Column_name | Collation | Cardinality | Sub_part | Packed | Null | Index_type | Comment |
        @indexes << {:name => row[2], :unique => row[1] == "0", :cardinality => 6, :columns => [], :index_type => 10}
      end
      @indexes.last[:columns] << row[4]
    end
  end
  
  def fields
    return @fields if @fields
    @fields = []
    Base.execute("show fields from #{sanitize_table name}").each do |row|
      @fields << {:name => row[0], :type => row[1], :null => row[2], :default => row[4], :extra => row[5]}
    end
    @fields
  end
  
  alias :old_method_missing :method_missing
  def method_missing(method, *args)
    return table_status[method.to_s] if table_status.has_key?(method.to_s)
    return old_method_missing(method, *args)
  end
  
  private
  def set_db
    Base.execute "use #{@db.name}"
  end
  
  def db_module
    db_camelized = db.name.camelize
    mod = db_camelized.constantize
  rescue NameError
    mod = Module.new
    def mod.const_missing name = nil
      raise NameError
    end
    Object.const_set db_camelized, mod
  ensure
    db_camelized.constantize
  end

  def create_custom_ar_class
    c = Class.new ActiveRecord::Base
    c.class_eval do
      define_method :attributes_protected_by_default do 
        []
      end
    end
    c
  end
    
end
