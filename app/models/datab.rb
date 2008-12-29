class Datab < Base
  include Collation
  
  attr_accessor :collation

  @@databs = {}

  def self.create! attributes
    options = {}
    if !attributes[:collation].blank?
      options[:collation] = attributes[:collation]
      options[:charset] = Collations.detect do |group|
        group.values.detect { |col| col.value == attributes[:collation] } 
      end.label
    end
    connection.create_database attributes[:name], options
  end
  
  def self.destroy! name
    execute "drop database #{sanitize_table name}"
    @@databs.delete name
  end

  def self.databs
    execute('SHOW DATABASES').each do |name|
      name = name.first
      @@databs[name] = (new name)
    end
    @@databs
  end

  def self.all
    databs.values.sort_by &:name
  end
  
  def self.find name
    databs[name.to_s]
  end

  def tables
    return @tables if @tables
    req = Base.execute("SHOW TABLES FROM #{sanitize_table name}")
    @tables = []
    req.each do |table|
      @tables << Table.new(table[0], self)
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
