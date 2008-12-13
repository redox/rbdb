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
        t.column *(Field.params_to_field_spec v)
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
    params[:fields].each do |k,v|
      args = [name, *(Field.params_to_field_spec v)]
      if f = fields.detect { |f| f.name == k }
        if f.name != v[:name]
          Base.connection.rename_column name, f.name, v[:name]
        end
        Base.connection.change_column *args unless f.same_as? v
      else
        Base.connection.add_column *args
      end
    end
    fields.each do |f|
      next if params[:fields].detect { |k,v| v[:name] == f.name }
      Base.connection.remove_column name, f.name
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
    c.set_inheritance_column
  ensure
    return c
  end

  def columns
    # resolve foreign keys
    columns = Base.connection.columns(ar_class.table_name)
    columns.each { |column| column.primary = column.name == ar_class.primary_key }
    columns.map do |c|
      if c.name =~ /_id$/ && t = @db.tables.detect {|t| t.name == c.name.gsub(/_id$/, '').pluralize}
        ForeignKey.new c, t
      else
        c
      end 
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
      end unless new_record?
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

  end
