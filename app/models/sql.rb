class Sql < Base
  attr_accessor :body, :limit, :offset
  attr_reader :results, :errors, :id
  
  DEFAULT_LIMIT = 30
  
  def initialize(params = nil)
    @errors = ActiveRecord::Errors.new(self)
    return if params.nil?
    update_attributes(params)
  end
  
  def new_record?
    (self.body.blank? or @id.nil?)
  end
  
  def save
    results
    @id = rand(9999999)
    return true
  rescue StandardError => e
    @errors.add :body, e
    return false
  end
  
  def results
    @results ||= execute(self.body)
  end
  
  def to_param
    @id
  end
  
  def num_rows
    results.num_rows
  end
  
  def columns(datab)
    results.fetch_fields.map do |f|
      t = datab.tables.detect {|t| t.name == f.table}
      t.nil? ? f : t.ar_class.columns.detect {|c| c.name == f.name}
    end
  end
  
  def rows(datab)
    res = []
    results.each do |row|
      r = {}
      columns(datab).each_with_index do |c, i|
        r[c.name] = row[i]
      end
      res << r
    end
    WillPaginate::Collection.create((offset / limit) + 1, limit) do |pager|
      pager.replace res
      pager.total_entries = num_rows
    end    
  end
  
  def limit=(v)
    @limit = v.to_i
    @limit = DEFAULT_LIMIT if @limit <= 0
  end
  
  def update_attributes(params)
    self.body = params[:body]
    @id = params[:id] if @id.nil?
    return true
  end
  
end
