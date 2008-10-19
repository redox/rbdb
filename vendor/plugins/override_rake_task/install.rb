# Insert line: [require "#{RAILS_ROOT}/vendor/plugins/override_rake_task/lib/override_rake_task.rb"]
# before "require 'rake'" in Rakefile
# stolen from app_confing plugin :) http://jarmark.org/projects/app-config/ 

file = File.join(File.dirname(__FILE__), '../../../Rakefile')
unless File.exists?(file)
    STDERR.puts("ERROR: Could not locate Rakefile") 
    exit(1)
end

# Tip from http://pleac.sourceforge.net/pleac_ruby/fileaccess.html
# 'Modifying a File in Place Without a Temporary File'
output= ""
inserted = false
line_to_insert = %q{require "#{RAILS_ROOT}/vendor/plugins/override_rake_task/lib/override_rake_task.rb"}
line_to_find = "require 'rake'"

File.open(file, 'r+') do |f|   # open file for update
    # read into array of lines and iterate through lines
    f.readlines.each do |line| 
        unless inserted 
            if line.gsub(/#.*/, '').include?(line_to_insert)
                inserted = true
            elsif line.gsub(/#.*/, '').include?(line_to_find)
                output << line_to_insert
                output << "\n\n"
                inserted = true
            end
        end     
        output << line
    end
    f.pos = 0                     # back to start
    f.print output                # write out modified lines
    f.truncate(f.pos)             # truncate to new length
end   

unless inserted
    STDERR.puts <<END 
ERROR: Could not update Rakefile
To finish installation please add the following line to 
Rakefile manually: 
\t#{line_to_insert}
NOTE: line must be inserted before #{line_to_find}
END
    exit(1)
end