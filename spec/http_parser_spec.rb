require_relative 'spec_helper'
require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\lib\request.rb'


describe 'Request' do

    describe 'Simple get-request' do
    
        it 'parses the http method' do
            request_string = File.read('C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\spec\example_requests\get-index.request.txt')
            request = Request.new(request_string)
            _(@request.method).must_equal method
        end

        it 'parses the resource' do
            request_string = File.read('C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\spec\example_requests\get-index.request.txt')
            request = Request.new(request_string)
            _(@request.resource).must_equal resource
        end

        
    end


end