class Relation < Base
  
  def self.dot(format, table, datab)
    gv = IO.popen("/usr/bin/dot -q -T#{format}", "w+") do |gv|
      gv.puts "digraph \"Relations of #{table.name}\" {"
      gv.puts <<-EOL
	graph [
		fontcolor = "black"
		color = "black"
		rankdir = "LR"
	]
	node [
		fontcolor = "black"
		shape = "ellipse"
		color = "black"
	]
	edge [
		fontcolor = "black"
		color = "black"
	]
EOL
      relations = Relation.with(table, datab)

      datab.tables.each do |t|
        next if !relations.include?(t.name)
        gv.puts <<-EOL
  "#{t.name}" [
    label = "<f0> #{t.name} | #{i = 0; t.columns.map { |c| "<f#{i += 1}> #{c.name}" }.join(' | ')}"
    shape = "record"
  ]
EOL
      end

      datab.tables.each do |t|
        i = 0
        t.columns.each do |c|
          i += 1
          next if !c.is_a?(ForeignKey) or !relations.include?(c.dest.name)
          gv.puts <<-EOL
  "#{t.name}":f#{i} -> "#{c.dest.name}":f1 [
  ]
EOL
        end
      end

      gv.puts "}"
      gv.close_write
      return gv.read
    end
  end
  
  def self.with(table, datab)
    res = []
    
    # select belongs_to relations
    res += Relation.belongs_to(table)
    
    # select has_many/one relations
    datab.tables.each do |t|
      r = Relation.belongs_to(t)
      next if (r & res).empty?
      res |= r
    end

    return res
  end
  
  def self.has_many(table, datab)
    res = []
    datab.tables.each do |t|
      next if t.name == table.name
      next if !t.columns.detect { |c| c.is_a?(ForeignKey) and c.dest.name == table.name }
      res << t.name
    end
    return res
  end
  
  def self.belongs_to(table)
    res = []
    tables = [table]

    while !tables.empty?
      t = tables.shift
      t.columns.select { |c| c.is_a?(ForeignKey) }.each do |c|
        next if res.include?(c.dest.name)
        tables << c.dest
      end
      res << t.name
    end
    return res
  end
  
end
