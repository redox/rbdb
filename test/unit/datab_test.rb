require 'test_helper'

class DatabTest < ActiveSupport::TestCase
  
  setup do
    ActiveRecord::Base.connection.execute "drop database rbdb_test1" rescue nil
    Datab.create :name => 'rbdb_test1'
    ActiveRecord::Base.connection.execute "drop database rbdb_test2" rescue nil
    Datab.create :name => 'rbdb_test2'
    ActiveRecord::Base.connection.execute "drop database rbdb_test3" rescue nil
    Datab.create :name => 'rbdb_test3'
  end
  
  should "find created databases" do
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test1'}, Datab.all.inspect
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test2'}, Datab.all.inspect
    assert Datab.all.detect {|datab| datab.name == 'rbdb_test3'}, Datab.all.inspect
  end
  
end
