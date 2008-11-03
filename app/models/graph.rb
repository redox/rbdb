require 'yaml'

class Graph
  attr_accessor :values

  def initialize table, field
    @table, @field, @values = table, field, []
  end

  def self.generate(table, field)
    graph = new table, field
    graph.compute
    graph.arrange_values
    graph.limit_to_ten
    return graph.values
  end

  def compute conditions = nil
    @values += @table.ar_class.
    find(:all,:group => @field, :order => "nb desc", :limit => 50,
    :select => "COUNT(*) AS nb, #{@field}", :conditions => conditions).
    map do |u|
      [(u.send(@field).to_s(:db) rescue u.send(@field).to_s), u.nb.to_i]
    end
  end

  def self.is_relevant? table, field
    return false if ['id', 'email', 'created_at'].include? field.name
    return false if field.primary
    distinct_values = table.ar_class.count("distinct #{field.name}")
    total_values = table.ar_class.count(field.name)
    return false if distinct_values == total_values
    return false if distinct_values == 1
    return true
  end

  def self.select_relevant_columns table
    table.ar_class.columns.reject do |column|
      !is_relevant? table, column
    end
  end

  def arrange_values
    total = @values.sum{|e|e[1]}.to_f
    other = 0
    i = @values.size - 1
    while i > 1 do
      break if (other + @values[i][1]) / total > 0.05
      other += @values[i][1]
      i = i - 1
    end
    return @values if i == 0 
    @values = @values[0..i].push ["Other", other]
  end

  def limit_to_ten
    p values
    if @values.size > 10
      @values[9] = ['Other', @values[9..-1].sum{|e|e[1]}]
      @values = @values[0..9]
    end
  end

  def self.generate_created_at table, evolution = nil
    datas = table.ar_class.count('id', :group => 'date(created_at)')
    if evolution
      i = 1
      datas = datas.map { |e| [e[0], e[1]]}
      while i < datas.size do
        datas[i][1] += datas[i - 1][1]
        i += 1 
      end
    end
    datas
  end

end
