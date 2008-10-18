class Datab < Base

  @@databs = {}

  def self.databs
    return @@databs unless @@databs.empty?
    ActiveRecord::Base.connection.execute("show databases").each do |name|
      name = name.first
      @@databs[name] = (new name)
    end
    @@databs
  end

  def self.all
    databs.values
  end
  
  def self.find name
    databs[name]
  end

  def tables
    return @tables if @tables
    req = ActiveRecord::Base.connection.execute("SHOW TABLE STATUS FROM #{name}")
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
