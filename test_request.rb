require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\lib\request.rb'

request_string = File.read('C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\spec\example_requests\get-index.request.txt')
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params

request_string = File.read('C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\spec\example_requests\get-fruits-with-filter.request.txt')
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params

request_string = File.read('C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi-main\Skibbidi-main\spec\example_requests\post-login.request.txt')
request = Request.new(request_string)
p request.method
p request.resource
p request.version
p request.headers
p request.params


