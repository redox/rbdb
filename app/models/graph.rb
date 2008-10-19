require 'yaml'

class Graph

  def self.generate(table, field)
    #filename = File.join(Rails.root, 'tmp', table.db.name + '_' + table.name + '_' + field + '.yml')
    values = []#YAML.load_file(filename) rescue []
    conditions = values.empty? ? nil : ["#{field} > ?", values.last.first]
    conditions = nil
    values += arrange_values compute(table, field, conditions)
    #File.open(filename, 'w') do |out|
    #  YAML.dump(values, out)
    #end
    return values
  end

  def self.compute(table, field, conditions = nil)
    table.ar_class.
    find(:all,:group => field, :order => "nb desc", :limit => 50,
    :select => "COUNT(*) AS nb, #{field}", :conditions => conditions).
    map do |u|
      [(u.send(field).to_s(:db) rescue u.send(field).to_s), u.nb.to_i]
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

  def self.arrange_values values
    total = values.sum{|e|e[1]}.to_f
    other = 0
    i = values.size - 1
    while i > 1 do
      break if (other + values[i][1]) / total > 0.05
      other += values[i][1]
      i = i - 1
    end
    return values if i == 0 
    values[0..i].push ["Other", other]
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
