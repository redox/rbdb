require 'yaml'

class Graph
  attr_accessor :values

  def initialize db, table, field
    @db, @table, @field, @values = db, table, field, []
  end

  def self.generate(db, table, field)
    graph = new db, table, field 
    graph.compute
    graph.arrange_values
    graph.limit_to_ten
    graph.display_empty_string_and_null
    if field =~ /_id$/ && t = db.tables.detect {|t| t.name == field.gsub(/_id$/, '').pluralize}
      if t.columns.detect { |c| c.name == "name" }
        ids = graph.values.map {|v| v[0] if (v[0] && v[0] != "Other") }
        ars = t.ar_class.find(ids, :select => 'id, name')
        graph.values.each_with_index do |orignal_value, index|
          if ar_found = ars.find {|ar| ar.id.to_s == orignal_value[0] }
            graph.values[index][0] = ar_found.name
          end
        end
      end
    end
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
  
  def display_empty_string_and_null
    @values = @values.map do |data|
      if (data[0])
        val = (data[0] == "") ? "EMPTY" : data[0]
      else
        val = "NULL"
      end
      [val, data[1]]
    end
  end
  
  def limit_to_ten
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
