require 'yaml'

class Graph
  
  def self.generate(table, field)
    filename = File.join(Rails.root, 'tmp', table.db.name + '_' + table.name + '_' + field + '.yml')
    values = YAML.load_file(filename) rescue []
    conditions = values.empty? ? nil : ["#{field} > ?", values.last.first]
    values += compute(table, field, conditions)
    File.open(filename, 'w') do |out|
      YAML.dump(values, out)
    end
    return values
  end
  
  def self.compute(table, field, conditions = nil)
    table.ar_class.
    find(:all,:group => field, :order => "#{field} ASC", :limit => 50,
      :select => "COUNT(*) AS nb, #{field}", :conditions => conditions).
      map do |u|
        [(u.send(field).to_s(:db) rescue u.send(field).to_s),
         u.nb.to_i]
      end
  end
  
  def self.is_relevant? table, field
    return false if ['id', 'email'].include? field.name
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
  
end
