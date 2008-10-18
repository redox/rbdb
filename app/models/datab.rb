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
    @tables = []
    ActiveRecord::Base.connection.execute("show full tables from #{name}").each do |table|
      @tables << (Table.new table[0], self, table[1])
    end
    @tables
  end

end
