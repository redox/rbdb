class Search < Base
  
  attr_reader :row, :conditions, :modifiers
  
  def initialize(table, params = {}, modifiers = {})
    super(table.name)
    @table = table
    @row = @table.ar_class.new params
    @modifiers = modifiers
  end
  
  def errors
    @row.errors
  end
  
  def options_for(attribute)
    res = [
      ['=', :equal],
      ['!=', :not_equal],
      ['<', :lesser_than],
      ['<=', :lesser_or_equal],
      ['>', :greater_than],
      ['>=', :greater_or_equal]
    ]
    
    column = @table.columns.detect { |c| c.name == attribute }
    case column.type
    when :string
      res += [
        ['LIKE', :like],
        ['NOT LIKE', :not_like]
      ]
    else
    end
    
    field = @table.fields.detect { |f| f.name == attribute }
    if field.null == "YES"
      res += [
        ['IS NULL', :is_null],
        ['IS NOT NULL', :is_not_null]
      ]
    end
    
    return res
  end
  
  def save
    conditions_list = []
    conditions_args = []
    @row.attributes.each do |attribute, value|
      column = @table.columns.detect { |c| c.name == attribute }
      mod = @modifiers[attribute].to_sym
      skip_mod = [:is_not_null, :is_null]
      skip_mod << [:equal] if column.text?
      next if value.blank? and !skip_mod.include?(mod)
      opt = options_for(attribute).detect {|o| o[1] == mod}.first
      raise "option not found" if opt.nil?
      case mod
      when :equal, :not_equal, :lesser_or_equal, :lesser_than, :greater_or_equal, :greater_than,
        :like, :not_like
        conditions_list << "#{attribute} #{opt} ?"
        conditions_args << value
      when :is_null, :is_no_null
        conditions_list << "#{attribute} #{opt}"
      else
        raise "never reached #{mod}"
      end
    end
    
    @conditions = [conditions_list.join ' AND ']
    @conditions += conditions_args
    @id = rand(999999)
    return true
  end
  
  def new_record?
    @id.nil?
  end
  
  def name
    @row.name
  end
  
  def to_param
    @id
  end 
  
  def id
    @id
  end
  
  alias :old_method_missing :method_missing
  def method_missing(method, *args)
    @row.send(method, *args) rescue old_method_missing(method, *args)
  end
  
end
