require 'test_helper'

class GraphTest < ActiveSupport::TestCase

  setup do
    ActiveRecord::Base.connection.execute "drop database rbdb_test4" rescue nil
    Datab.create :name => 'rbdb_test4'
    ActiveRecord::Base.connection.execute "use rbdb_test4"
    ActiveRecord::Base.connection.create_table 'table1' do |t|
      t.string :email
      t.integer :another_field
      t.datetime :created_at
      t.string :language, :default => 'FR'
      t.integer :many_values
    end
    @table = Datab.find('rbdb_test4').tables.first
    1.upto 200 do |i| 
      @table.ar_class.create :another_field => (i % 4), :created_at => ("10-10-2000".to_date + i.day), :many_values => i % 51
    end
  end

  should "not consider id and email column relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[0])
    assert !Graph.is_relevant?(@table, @table.columns[1])
  end
  
  should "not consider a column with all values distinct relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[3])
  end
  
  should "not consider a column with only one distinct value relevant" do
    @table = Datab.find('rbdb_test4').tables.first
    assert !Graph.is_relevant?(@table, @table.columns[4])
  end
  
  should "not consider render a pie with more than 50 values" do
    @table = Datab.find('rbdb_test4').tables.first
    assert_equal 50, Graph.compute(@table, @table.columns[5].name).size
  end
  
  should "get all the relevant columns of the table" do
    @table = Datab.find('rbdb_test4').tables.first
    columns = Graph.select_relevant_columns @table
    assert_equal ['another_field', 'many_values'], columns.map(&:name)
  end

end
