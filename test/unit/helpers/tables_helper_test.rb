require File.dirname(__FILE__) + '/../../test_helper'

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

  should "add mailto link" do
    assert_match '<a href="mailto', string('jacko@gmail.com')
  end
  
  should "add http link" do
    assert_match '<a href="http://', string('http://massivebraingames.com')
  end
  
  should "truncate long string" do
    assert_match '<span title="en voila une longue string">en voila une long...</span>', string('en voila une longue string')
  end
  
end