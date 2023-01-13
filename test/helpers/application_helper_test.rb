require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test 'full_title called with no args returns a title with no prefix' do
    assert_equal 'Ruby on Rails Tutorial Sample App', full_title
  end

  test 'full_title called with an argument uses it as a prefix' do
    assert_equal 'About | Ruby on Rails Tutorial Sample App', full_title('About')
  end
end
