class Field < Base
  
  attr_accessor :name, :default, :null, :type, :extra, :limit, :primary
  
  def initialize(params = {})
		self.null = true
		params.each do |k, v|
			self.send "#{k}=", v
		end
  end
  
  def self.types
    Base.connection.native_database_types.select { |k, v| v[:name] }.map do |k, v|
      [k.to_s, k.to_s]
    end
  end
  
  def self.extra
    [["None", nil], ["auto_increment", "auto_increment"]]
  end
  
  def rtype
    return nil if self.type.blank?
    case self.type.to_s
    when 'tinyint'
      self.limit == 1 ? 'boolean' : 'integer'
    when 'datetime'
      'timestamp'
    when 'blob'
      'binary'
    when 'varchar'
      'string'
    when 'int', 'smallint', 'mediumint', 'bigint'
      'integer'
    else
      self.type.to_s
    end
  end

	def same_as? field_spec
		rtype == field_spec[:type] and
      (field_spec[:null].blank? or null == (field_spec[:null] == "1")) and 
      (field_spec[:extra].blank? or extra == field_spec[:extra]) and
      (field_spec[:default].blank? or Field.sql_value(default) == Field.sql_value(field_spec[:default])) and
      (field_spec[:limit].blank? or Field.limit_value(field_spec[:limit]) == Field.limit_value(limit))
	end

	def self.params_to_field_spec params
		[params[:name], params[:type].to_sym, {
      :null => params[:null],
      :limit => limit_value(params[:limit]),
      :extra => params[:extra],
      :default => sql_value(params[:default])
    }]
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
