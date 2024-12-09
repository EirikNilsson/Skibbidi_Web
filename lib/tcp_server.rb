require 'socket'
require_relative 'request'
require_relative 'router'

class HTTPServer
  def initialize(port)
    @port = port
    @router = Router.new

    @router.add_route('/fruit') do
      fruits = ['Apple', 'Banana', 'Orange', 'Pear', 'Grape']
      fruit = fruits.sample
      "<html><body><h1>Random fruit: #{fruit}</h1></body></html>"
    end

    @router.add_route('/') do
      "<html><body><h1>Welcome to my server!</h1></body></html>"
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
        html = route_block.call
        session.print "HTTP/1.1 200 OK\r\n"
        session.print "Content-Type: text/html\r\n"
        session.print "Content-Length: #{html.bytesize}\r\n"
        session.print "\r\n"
        session.print html
      else
        html = "<html><body><h1>404 Not Found</h1></body></html>"
        session.print "HTTP/1.1 404 Not Found\r\n"
        session.print "Content-Type: text/html\r\n"
        session.print "Content-Length: #{html.bytesize}\r\n"
        session.print "\r\n"
        session.print html
      end

      session.close
    end
  end
end

server = HTTPServer.new(4567)
server.start
