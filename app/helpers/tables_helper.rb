module TablesHelper

  def most_likely_name r
    if r.respond_to? :name
      r.name
    else
      r.attributes.find {|c, v| v.is_a? String }[1]
    end
  end
  
end
