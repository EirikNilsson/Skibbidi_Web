# frozen_string_literal: true

require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\lib\request'
require 'minitest/autorun'
require 'minitest/reporters'

Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new

# File paths for test request files
REQUESTS_PATH = 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\spec\example_requests'
GET_INDEX_PATH = File.join(REQUESTS_PATH, 'get-index.request.txt')
GET_FRUITS_PATH = File.join(REQUESTS_PATH, 'get-fruits-with-filter.request.txt')
POST_LOGIN_PATH = File.join(REQUESTS_PATH, 'post-login.request.txt')

describe 'Request' do
  describe 'Simple GET request' do
    before do
      request_string = File.read(GET_INDEX_PATH)
      @request = Request.new(request_string)
    end

    describe 'parsing HTTP components' do
      it 'parses the HTTP method' do
        _(@request.http_method).must_equal 'GET'
      end

      it 'parses the resource' do
        _(@request.resource).must_equal '/'
      end

      it 'parses the HTTP version' do
        _(@request.version).must_equal 'HTTP/1.1'
      end
    end

    describe 'parsing headers and params' do
      it 'parses the headers' do
        expected_headers = { 'Host' => 'developer.mozilla.org', 'Accept-Language' => 'fr' }
        _(@request.headers).must_equal expected_headers
      end

      it 'parses empty params for requests without query or body' do
        _(@request.params).must_equal({})
      end
    end
  end

  describe 'GET request with query parameters' do
    before do
      request_string = File.read(GET_FRUITS_PATH)
      @request = Request.new(request_string)
    end

    describe 'parsing HTTP components' do
      it 'parses the HTTP method' do
        _(@request.http_method).must_equal 'GET'
      end

      it 'parses the resource' do
        _(@request.resource).must_equal '/fruits'
      end

      it 'parses the HTTP version' do
        _(@request.version).must_equal 'HTTP/1.1'
      end
    end

    describe 'parsing headers and query params' do
      it 'parses the headers' do
        expected_headers = {
          'Host' => 'fruits.com',
          'User-Agent' => 'ExampleBrowser/1.0',
          'Accept-Encoding' => 'gzip, deflate',
          'Accept' => '*/*'
        }
        _(@request.headers).must_equal expected_headers
      end

      it 'parses query parameters into params' do
        expected_params = { 'type' => 'bananas', 'minrating' => '4' }
        _(@request.params).must_equal expected_params
      end
    end
  end

  describe 'POST request with body parameters' do
    before do
      request_string = File.read(POST_LOGIN_PATH)
      @request = Request.new(request_string)
    end

    describe 'parsing HTTP components' do
      it 'parses the HTTP method' do
        _(@request.http_method).must_equal 'POST'
      end

      it 'parses the resource' do
        _(@request.resource).must_equal '/login'
      end

      it 'parses the HTTP version' do
        _(@request.version).must_equal 'HTTP/1.1'
      end
    end

    describe 'parsing headers and body params' do
      it 'parses the headers' do
        expected_headers = {
          'Host' => 'foo.example',
          'Content-Type' => 'application/x-www-form-urlencoded',
          'Content-Length' => '39'
        }
        _(@request.headers).must_equal expected_headers
      end

      it 'parses body parameters into params' do
        expected_params = { 'username' => 'grillkorv', 'password' => 'verys3cret!' }
        _(@request.params).must_equal expected_params
      end
    end
  end
end
