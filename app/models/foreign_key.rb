class ForeignKey
  
  attr_reader :source, :dest
  
  def initialize(source, dest)
    @source = source
    @dest = dest
  end
  
  def method_missing(method, *args)
    source.send(method, *args)
  end
  
end