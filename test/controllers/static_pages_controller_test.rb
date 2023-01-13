require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end


  test 'root URL returns Home page' do
    get root_path
    assert_response :success
    assert_select 'title', "#{@base_title}"
  end

  test 'should get Home page' do
    get root_path
    assert_response :success
    assert_select 'title', "#{@base_title}"
  end

  test 'should get Help page' do
    get help_path
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get About page' do
    get about_path
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end

  test 'should get Contact page' do
    get contact_path
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end
end
