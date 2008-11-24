class Table < Base
  
  attr_reader :db, :table_status
  attr_accessor :errors
  
  def initialize name, db
    super name
    @db = db
    req = Base.execute("SHOW TABLE STATUS FROM #{sanitize_table db.name} WHERE name='#{name}'")
    columns = req.fetch_fields.map { |f| f.name }
    @table_status = {}
    req.each do |v|
      columns.each_with_index do |c,i|
        @table_status[c.to_s.downcase] = v[i]
      end
    end
    @errors = ActiveRecord::Errors.new(self)
  end
  
  def self.create(params, db)
    p = params[:fields].detect { |k,v| v[:primary] }
    p = p.nil? ? {} : p[1]
    connection.create_table params[:name], :id => false, :primary => p[:name] do |t|
      params[:fields].each do |k,v|
        t.column v[:name], v[:type].to_sym, {
          :null => v[:null],
          :limit => limit_value(v[:limit]),
          :extra => v[:extra],
          :default => sql_value(v[:default])
        }
      end
    end
    return Table.new(params[:name], db)
  rescue ActiveRecord::StatementInvalid => e
    t = Table.new params[:name], db
    t.errors.add :name, e.to_s
    t.new_record = true
    return t
  end
  
  def update(params)
    # modify fields
    params[:fields].each do |k,v|
      f = fields.detect { |f| f.name == k }
      # a new field
      next if f.nil?
      # field name changed
      if f.name != v[:name]
        Base.connection.rename_column name, f.name, v[:name]
      end
      # column has not been modified
      next if f.rtype == v[:type] and
        (v[:null].blank? or f.null == (v[:null] == "1")) and 
        (v[:extra].blank? or f.extra == v[:extra]) and
        (v[:default].blank? or Table.sql_value(f.default) == Table.sql_value(v[:default])) and
        (v[:limit].blank? or Table.limit_value(v[:limit]) == Table.limit_value(f.limit))
      Base.connection.change_column name, v[:name], v[:type].to_sym, {
        :null => v[:null],
        :limit => Table.limit_value(v[:limit]),
        :extra => v[:extra],
        :default => Table.sql_value(v[:default])
      }
    end
    # remove fields
    fields.each do |f|
      next if params[:fields].detect { |k,v| v[:name] == f.name }
      Base.connection.remove_column name, f.name
      params[:fields].delete_if { |k,v| v[:name] == f.name }
    end
    # add fields
    params[:fields].each do |k,v|
      next if fields.detect { |f| f.name == v[:name] }
      Base.connection.add_column name, v[:name], v[:type].to_sym, {
        :null => v[:null],
        :limit => Table.limit_value(v[:limit]),
        :extra => v[:extra],
        :default => Table.sql_value(v[:default])
      }
    end
  rescue ActiveRecord::StatementInvalid => e
    @errors.add :name, e.to_s
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
    # resolve foreign keys
    columns = Base.connection.columns(ar_class.table_name)
    columns.each { |column| column.primary = column.name == ar_class.primary_key }
    columns.map do |c|
      if c.name =~ /_id$/
        if t = @db.tables.detect {|t| t.name == c.name.gsub(/_id$/, '').pluralize}
          ForeignKey.new c, t
          next
        end
      end
      c
    end
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
    @fields = []
    Base.execute("show fields from #{sanitize_table name}").each do |row|
      s = row[1].split('(')
      @fields << Field.new(:name => row[0],
        :type => s.first,
        :limit => s.size == 2 ? s.last.split(')').first : nil,
        :null => row[2] == "YES",
        :default => row[4],
        :extra => row[5],
        :primary => row[3] == "PRI")
    end
    @fields
  end
  
  alias :old_method_missing :method_missing
  def method_missing(method, *args)
    return table_status[method.to_s] if table_status.has_key?(method.to_s)
    return old_method_missing(method, *args)
  end
  
  private
  
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
  
  def self.sql_value(v)
    return nil if v.blank? or v == "NULL"
    return v
  end
  
  def self.limit_value(v)
    return v if v.is_a?(Fixnum)
    return nil if v.blank? or v.to_i == 0
    return v.to_i
  end
    
end
