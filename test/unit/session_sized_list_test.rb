require File.dirname(__FILE__) + '/../test_helper'

class SessionSizedListTest < Test::Unit::TestCase

  def setup
    @session = {}
  end
  
  include SessionSizedList
  
  should 'add to session' do
    add_to_session :tables, {:name => 'cool'}
    assert_equal 1, session.size
    add_to_session :tables, {:name => 'super cool'}
    assert_equal 1, session.size
  end
  
  should 'limit list in session' do
    1.upto 5 do |i|
      add_to_session :tables, {:name => "cool#{i}"}
    end
    assert_equal 3, session[:tables].size
  end
  
  protected
  def session
    @session
  end
end