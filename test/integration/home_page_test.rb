require 'test_helper'

class HomePageTest < ActionDispatch::IntegrationTest
  test 'home page' do
    get root_path

    assert_select 'a[href=?]', signup_path
  end
end
