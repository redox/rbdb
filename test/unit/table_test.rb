require File.dirname(__FILE__) + '/../test_helper'

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
  
  should "allow mass assignment on id" do
    @datab = Datab.find('rbdb_test3')
    row = @datab.tables[0].ar_class.create :id => 137, :field1 => 3378
    assert_equal 137, row.id
  end
  
  should "create a new table" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table',
      :fields => [
        {:name => 'id', :type => 'integer', :options => {}},
        {:name => 'field1', :type => 'string', :options => {:limit => 32}}
      ]
    }
    Table.create!(params, @datab, 'id')
    t = @datab.tables.find 'new_table'
    assert_not_nil t
    assert_equal 2, t.columns.size
    assert t.columns[0].primary
    assert_equal 32, t.columns[1].limit
  end
  
  should "create a new table without id/primary key" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table2',
      :fields => [
        {:name => 'field1', :type => 'decimal', :options => {:precision => 2}}
      ]
    }
    Table.create!(params, @datab)
    t = @datab.tables.find 'new_table2'
    assert_not_nil t
    assert_equal 1, t.columns.size
    assert_equal 2, t.columns[0].precision
  end
  
  should "fail adding an existing table" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table3',
      :fields => [
        {:name => 'field1', :type => 'decimal', :options => {:precision => 2}}
      ]
    }
    Table.create!(params, @datab)
    t = @datab.tables.find 'new_table3'
    assert_not_nil t

    assert_raise ActiveRecord::StatementInvalid do
      Table.create!(params, @datab)
    end
  end

end
