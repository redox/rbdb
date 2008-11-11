def test
  raise LoadError
rescue LoadError
  puts "rescued"
end

test