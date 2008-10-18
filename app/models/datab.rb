class Datab < Base
  @@databs = {}

  def self.fetch_all
    ActiveRecord::Base.connection.execute("show databases").each do |name|
      name = name.first
      @@databs[name] = (new name)
    end
  end

  def self.all
    Datab.fetch_all if @@databs.empty?
    @@databs.values
  end
  
  def self.find name
    Datab.fetch_all if @@databs.empty?
    @@databs[name]
  end

  def tables
    return @tables if @tables
    @tables = []
    ActiveRecord::Base.connection.execute "use #{name}"
    ActiveRecord::Base.connection.execute("show tables").each do |name|
      name = name.first
      @tables << (Table.new name, self)
    end
    @tables
  end

end

