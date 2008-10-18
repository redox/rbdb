require 'yaml'

class Graph
  
  def self.generate(table, field)
    filename = Rails.root.join('db', table.db.name + '_' + table.name + '.yml')
    values = YAML.load_file(filename) rescue []
    values += table.ar_class.count(:group => 'date(created_at)', :order => 'created_at ASC',
      :conditions => ['created_at > ?', values.last.first])
    File.open(filename, 'w') do |out|
      YAML.dump(values, out)
    end
    return values
  end
  
end
