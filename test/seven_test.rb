ENV['RACK_ENV']= 'test'

require 'minitest/autorun'
require 'rack/test'
require 'fileutils'

require_relative '../seven'

class SevenTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def setup
  end

  def teardown
  end

  def session
    last_request.env['rack.session']
  end 

  def test_index
    get '/'
    assert_equal 302, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]

    get last_response['Location']
    assert_includes last_response.body, 'Welcome to the Seven Second Game'
  end

  def test_home
    get '/home'
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, 'Where Laughter and Chaos'
  end

  def test_instructions
    get '/instructions'
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, 'At the end of 5 rounds'
  end

  def test_not_found
    get '/notaplace'
    assert_equal 302, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]

    assert_includes session[:error], "Here's a familiar place"
  end
  
  def test_signin_page
    get '/signin'
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Please sign in" && "Don't have an account?"
  end

  def test_signup_page
    get '/signup'
    assert_equal 200, last_response.status
    assert_equal "text/html;charset=utf-8", last_response["Content-Type"]
    assert_includes last_response.body, "Please sign up" && "Already have an account?"
  end

end
