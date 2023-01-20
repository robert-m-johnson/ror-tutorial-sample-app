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
end
