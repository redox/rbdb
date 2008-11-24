require File.dirname(__FILE__) + '/../test_helper'

class FieldTest < ActiveSupport::TestCase
	
	should 'know when a field is the same as a field spec or not' do
		field = Field.new :name => 'age', :type => 'integer', :limit => 8
		assert (field.same_as? :name => 'age', :null => '1', :type => 'integer', :limit => 8)
		assert (field.same_as? :name => 'age', :type => 'integer', :limit => 8)
		assert !(field.same_as? :name => 'age', :default => '37', :type => 'integer', :limit => 8)
	end
	
end