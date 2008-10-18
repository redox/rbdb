class Base
  
  attr_reader :name
  
  def initialize name
    @name = name
  end
  
  def to_param
    name
  end
  
  alias :id :name
  
end
