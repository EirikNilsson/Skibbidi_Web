# frozen_string_literal: true

require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\lib\request'

# Define constants for file paths
REQUESTS_PATH = 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\spec\example_requests'
GET_INDEX_PATH = File.join(REQUESTS_PATH, 'get-index.request.txt')
GET_FRUITS_PATH = File.join(REQUESTS_PATH, 'get-fruits-with-filter.request.txt')
POST_LOGIN_PATH = File.join(REQUESTS_PATH, 'post-login.request.txt')

# Simple GET request
request_string = File.read(GET_INDEX_PATH)
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params

# GET request with query parameters
request_string = File.read(GET_FRUITS_PATH)
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params

# POST request with body parameters
request_string = File.read(POST_LOGIN_PATH)
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params