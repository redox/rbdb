require 'test_helper'

class TableTest < ActiveSupport::TestCase
  
  def setup
    super
    create_database 'rbdb_test3' do |datab|
      datab.create_table 'table1' do |t|
        t.integer :field1
      end
      datab.create_table 'table2' do |t|
        t.string :field1
        t.string :field2
      end
    end
  end
  
  should "test the view status of a table" do
    @datab = Datab.find('rbdb_test3')
    assert !@datab.tables[0].view?
  end
  
  should "get the associated ar class" do
    @datab = Datab.find('rbdb_test3')
    assert @datab.tables[1].ar_class
  end
  
  should "get the columns of a table" do
    @datab = Datab.find('rbdb_test3')
    t1 = @datab.tables[0]
    assert_equal 2, t1.columns.size
    
    t2 = @datab.tables[1]    
    assert_equal 3, t2.columns.size
  end
  
end
