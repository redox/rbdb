class Field < Base
  
  attr_accessor :name, :default, :null, :type, :extra, :limit, :primary
  
  def initialize(params = {})
    self.name = params[:name]
    self.default = params[:default]
    self.null = params[:null].nil? ? true : params[:null]
    self.type = params[:type]
    self.extra = params[:extra]
    self.limit = params[:limit]
    self.primary = params[:primary]
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
end