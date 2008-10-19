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
  
  def self.compute(table, field, conditions)
    table.ar_class.
    find(:all,:group => field, :order => "#{field} ASC", :limit => 50,
      :select => "COUNT(*) AS nb, #{field}", :conditions => conditions).
      map do |u|
        [(u.send(field).to_s(:db) rescue u.send(field).to_s),
         u.nb.to_i]
      end
  end
  
end
