require 'socket'
require_relative 'request'
require_relative 'router'
require_relative 'response'

class HTTPServer
  def initialize(port)
    @port = port
    @router = Router.new

    @router.add_route('GET', '/fruit') do
      "<html><body><h1>Welcome to my Fruit Page!</h1></body></html>"
    end
    @router.add_route('GET', '/fruit/:id') do |params|
      fruits = ['Apple', 'Banana', 'Orange', 'Pear', 'Grape']
      id = params['id'].to_i
      fruit = fruits[id] || 'Unknown'
      "<html><body><h1>Fruit: #{fruit}</h1></body></html>"
    end
    @router.add_route('POST', '/fruit') do |params|
      new_fruit = params['name'] || 'Unnamed Fruit'
      "<html><body><h1>New Fruit Created: #{new_fruit}</h1></body></html>"
    end

  end

  def start
    server = TCPServer.new(@port)
    puts "Listening on port #{@port}"

    while session = server.accept
      data = ""
      while (line = session.gets) && (line !~ /^\s*$/)
        data += line
      end

      puts "RECEIVED REQUEST"
      puts "-" * 40
      puts data
      puts "-" * 40

      request = Request.new(data)
      route_block = @router.match_route(request)

      if route_block
        html = route_block.call(request.params) # Skicka parametrarna till blocket
        Response.build(session, status_code: 200, body: html)
      else
        html = "<html><body><h1>404 Not Found</h1></body></html>"
        Response.build(session, status_code: 404, body: html)
      end
      

      session.close
    end
  end
end

server = HTTPServer.new(4567)
server.start
