require 'test/test_helper'

class TablesHelperTest < ActionView::TestCase
  
  should "match today" do
    assert_match 'Today', datetime(Date.today)
  end
  
  should "match yesterday" do
    assert_match 'Yesterday', datetime(Date.yesterday)
  end
  
  should "match months ago" do
    assert_match 'months ago', datetime(2.month.ago)
  end
  
  should "match days ago" do
    assert_match 'days ago', datetime(12.days.ago)
  end
  
end