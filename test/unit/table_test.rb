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
      
      datab.create_table 'users' do |t|
      end
      
      datab.create_table 'addresses' do |t|
        t.integer :user_id
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
    t1 = @datab.tables.detect{|table|table.name == 'table1'}
    assert_equal 2, t1.columns.size
    
    t2 = @datab.tables.detect{|table|table.name == 'table2'}
    assert_equal 3, t2.columns.size
  end
  
  should "allow mass assignment on id" do
    @datab = Datab.find('rbdb_test3')
    row = @datab.tables.detect{|table|table.name == 'table1'}.ar_class.create :id => 137, :field1 => 3378
    assert_equal 137, row.id
  end
  
  should "create a new table" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => true},
        'field1' => {:name => 'field1', :type => 'string', :limit => 32}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t = @datab.tables.find 'new_table'
    assert_not_nil t
    assert_equal 2, t.columns.size
    assert t.columns.detect{ |c| c.name == "id" }.primary
    assert_equal 32, t.columns.detect{ |c| c.name == "field1" }.limit
  end
  
  should "create a new table without id/primary key" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table2',
      :fields => {
        'field1' => {:name => 'field1', :type => 'decimal', :null => "1"}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t = @datab.tables.find 'new_table2'
    assert_not_nil t
    assert_equal 1, t.columns.size
    assert t.columns[0].null
  end
  
  should "fail adding an existing table" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table3',
      :fields => {
        'field1' => {:name => 'field1', :type => 'decimal'}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t = @datab.tables.find 'new_table3'
    assert_not_nil t

    t = Table.create(params, @datab)
    assert !t.errors.empty?
  end
  
  should "add columns" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table4',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => "1"},
        'field1' => {:name => 'field1', :type => 'string', :limit => "32", :default => 'test'}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t.update :fields => {
      'id' => {:name => 'id', :type => 'integer', :primary => "1", :limit => "11", :default => ''},
      'field1' => {:name => 'field1', :type => 'string', :limit => "32", :default => 'test'},
      'toto' => {:name => 'toto', :type => 'integer', :null => "1", :default => nil, :limit => 1}
    }
    assert t.errors.empty?
    assert_equal 3, t.columns.size
  end

  should "remove columns" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table5',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => true},
        'field1' => {:name => 'field1', :type => 'string', :limit => 32}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t.update :fields => {
      'id' => {:name => 'id', :type => 'integer', :primary => true},
    }
    assert t.errors.empty?
    assert_equal 1, t.columns.size
  end

  should "modify columns" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table6',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => "1"},
        'field1' => {:name => 'field1', :type => 'string', :limit => "32", :default => 'test'}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t.update :fields => {
      'id' => {:name => 'id', :type => 'integer', :primary => "1"},
      'field1' => {:name => 'field1', :type => 'string', :limit => "255", :default => 'test'}
    }
    assert t.errors.empty?
    assert_equal 2, t.columns.size
    assert_equal 255, t.columns.detect { |c| c.name == "field1" }.limit
  end

  should "modify, add and remove columns" do
    @datab = Datab.find('rbdb_test3')
    params = {
      :name => 'new_table7',
      :fields => {
        'id' => {:name => 'id', :type => 'integer', :primary => "1"},
        'field1' => {:name => 'field1', :type => 'string', :limit => "32", :default => 'test'}
      }
    }
    t = Table.create(params, @datab)
    assert t.errors.empty?
    t.update :fields => {
      'field1' => {:name => 'field1', :type => 'string', :limit => "255", :default => 'test'},
      'id3' => {:name => 'id3', :type => 'integer', :limit => "1", :default => '12'}
    }
    assert t.errors.empty?
    assert_equal 2, t.columns.size
    assert_equal 255, t.columns.detect { |c| c.name == "field1" }.limit
    assert t.columns.detect { |c| c.name == "id3" }
    assert_nil t.columns.detect { |c| c.name == "id" }
  end
  
  should "handle foreign key fields" do
    @datab = Datab.find('rbdb_test3')
    assert_equal ['id', 'user_id'], @datab.tables.detect{ |table| table.name == "addresses" }.columns.map(&:name)
  end
end
