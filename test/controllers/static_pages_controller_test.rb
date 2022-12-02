require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end


  test 'root URL returns Home page' do
    get root_url
    assert_response :success
    assert_select 'title', "Home | #{@base_title}"
  end

  test 'should get Home page' do
    get static_pages_home_url
    assert_response :success
    assert_select 'title', "Home | #{@base_title}"
  end

  test 'should get Help page' do
    get static_pages_help_url
    assert_response :success
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get About page' do
    get static_pages_about_url
    assert_response :success
    assert_select 'title', "About | #{@base_title}"
  end

  test 'should get Contact page' do
    get static_pages_contact_url
    assert_response :success
    assert_select 'title', "Contact | #{@base_title}"
  end
end
