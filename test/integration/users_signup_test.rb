require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '',
                                         email: 'user@invalid',
                                         password: 'foo',
                                         password_confirmation: 'bar' } }
      assert_response :unprocessable_entity
      assert_template 'users/new'

      assert_select '#error_explanation>ul>li', count: 4 do |list_items|
        error_messages = list_items.map(&:text)
        assert_equal ["Name can't be blank",
                      'Email is invalid',
                      "Password confirmation doesn't match Password",
                      'Password is too short (minimum is 6 characters)'],
                     error_messages
      end
    end
  end

  test 'valid signup information' do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: 'Bob Hagarty',
                                         email: 'bob123@example.com',
                                         password: 'StrongPassword123$',
                                         password_confirmation: 'StrongPassword123$' } }
      follow_redirect!

      assert_response :success
      assert_template 'users/show'

      assert_not_empty flash
      assert_select 'div.alert-success' do |elements|
        assert_not_empty elements
      end
    end
  end
end
