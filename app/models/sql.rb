class Sql < Base
  attr_accessor :body
  attr_reader :results, :errors, :id
  
  @@id = 0
  
  def initialize(params = nil)
    @errors = ActiveRecord::Errors.new(self)
    return if params.nil?
    self.body = params[:body]
    @id = params[:id]
  end
  
  def new_record?
    (self.body.blank? or @id.nil?)
  end
  
  def save
    @results = ActiveRecord::Base.connection.execute(self.body)
    @id = (@@id += 1)
    return true
  rescue StandardError => e
    @errors.add :body, e
    return false
  end
  
  def self.human_attribute_name(attribute)
    case attribute.to_s
    when 'body'
      "Body"
    else
      raise "never reached #{attribute}"
    end
  end
  
  def to_param
    id
  end
  
end
