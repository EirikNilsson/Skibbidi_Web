# frozen_string_literal: true

# Initialize SimpleCov to measure code coverage
require 'simplecov'
SimpleCov.start

# Require necessary files
require_relative 'C:/Users/eirik.haugennilsson/Desktop/Programering 2/Skibbidi/lib/request'
require 'minitest/autorun'
require 'minitest/reporters'


# Define constants for file paths
REQUESTS_PATH = 'C:/Users/eirik.haugennilsson/Desktop/Programering 2/Skibbidi/spec/example_requests'
GET_INDEX_PATH = File.join(REQUESTS_PATH, 'get-index.request.txt')
GET_FRUITS_PATH = File.join(REQUESTS_PATH, 'get-fruits-with-filter.request.txt')
POST_LOGIN_PATH = File.join(REQUESTS_PATH, 'post-login.request.txt')

# Helper method to test common HTTP components
def assert_http_components(request, expected_method, expected_resource, expected_version)
  _(request.http_method).must_equal expected_method
  _(request.resource).must_equal expected_resource
  _(request.version).must_equal expected_version
end

# Test suite for Request class
describe 'Request' do
  describe 'Simple GET request' do
    before do
      request_string = File.read(GET_INDEX_PATH)
      @request = Request.new(request_string)
    end

    it 'parses HTTP components correctly' do
      assert_http_components(@request, 'GET', '/', 'HTTP/1.1')
    end

    it 'parses headers and params' do
      expected_headers = { 'Host' => 'developer.mozilla.org', 'Accept-Language' => 'fr' }
      _(@request.headers).must_equal expected_headers
      _(@request.params).must_equal({})
    end
  end

  describe 'GET request with query parameters' do
    before do
      request_string = File.read(GET_FRUITS_PATH)
      @request = Request.new(request_string)
    end

    it 'parses HTTP components correctly' do
      assert_http_components(@request, 'GET', '/fruits', 'HTTP/1.1')
    end

    it 'parses headers and query params' do
      expected_headers = {
        'Host' => 'fruits.com',
        'User-Agent' => 'ExampleBrowser/1.0',
        'Accept-Encoding' => 'gzip, deflate',
        'Accept' => '*/*'
      }
      expected_params = { 'type' => 'bananas', 'minrating' => '4' }
      _(@request.headers).must_equal expected_headers
      _(@request.params).must_equal expected_params
    end
  end

  describe 'POST request with body parameters' do
    before do
      request_string = File.read(POST_LOGIN_PATH)
      @request = Request.new(request_string)
    end

    it 'parses HTTP components correctly' do
      assert_http_components(@request, 'POST', '/login', 'HTTP/1.1')
    end

    it 'parses headers and body params' do
      expected_headers = {
        'Host' => 'foo.example',
        'Content-Type' => 'application/x-www-form-urlencoded',
        'Content-Length' => '39'
      }
      expected_params = { 'username' => 'grillkorv', 'password' => 'verys3cret!' }
      _(@request.headers).must_equal expected_headers
      _(@request.params).must_equal expected_params
    end
  end
end
