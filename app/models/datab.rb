class Datab < Base

  @@databs = {}

  def self.create attributes
    ActiveRecord::Base.connection.create_database attributes[:name]
  end

  def self.databs
    execute('show databases').each do |name|
      name = name.first
      @@databs[name] = (new name)
    end
    @@databs
  end

  def self.all
    databs.values.sort_by &:name
  end
  
  def self.find name
    databs[name]
  end

  def tables
    return @tables if @tables
    req = ActiveRecord::Base.connection.execute("SHOW TABLE STATUS FROM #{sanitize_table name}")
    columns = req.fetch_fields.map { |f| f.name }
    @tables = []
    req.each do |table|
      status = {}
      columns.each_with_index do |c, i|
        status[c.to_s.downcase] = table[i]
      end
      @tables << (Table.new table[0], self, status)
    end
    @tables.instance_eval do
      alias :old_find :find
      def find id
        old_find {|e| e.id == id }
      end
    end
    @tables
  end
  
end
