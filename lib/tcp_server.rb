# tcp_server.rb
require 'socket'
require 'erb'
require 'uri'

require_relative 'request'
require_relative 'response'
require_relative 'router'
require_relative 'router_setup'
require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\app.rb'

MIME_TYPES = {
  '.html' => 'text/html',
  '.css'  => 'text/css',
  '.js'   => 'application/javascript',
  '.png'  => 'image/png',
  '.jpg'  => 'image/jpeg',
  '.jpeg' => 'image/jpeg',
  '.gif'  => 'image/gif',
  '.txt'  => 'text/plain'
}

def get_mime_type(file_path)
  ext = File.extname(file_path).downcase
  MIME_TYPES[ext] || 'application/octet-stream'
end

class HTTPServer
  BASE_DIR = File.expand_path("../public/img", __dir__)

  def erb(template_path)
    file_path = "#{template_path}.erb"
    template = File.read(file_path)
    ERB.new(template).result(binding)
  end

  def initialize(port)
    @port = port
    @router = Router.new
    app = App.new
    app.setup_routes(@router)

  end

  def start
    server = TCPServer.new(@port)
    puts "Listening on port #{@port}"
  
    while session = server.accept
      data = ""
      while (line = session.gets) && (line !~ /^\s*$/)
        data += line
      end
  
      headers = data.split("\r\n")
      content_length = headers.find { |h| h =~ /Content-Length:/i }
      body = ""
  
      if content_length
        length = content_length.split(":")[1].strip.to_i
        body = session.read(length)
      end
  
      full_request = data + "\r\n\r\n" + body
  
      puts "FULL REQUEST:\n#{full_request}"
  
      request = Request.new(full_request)
      route_block = @router.match_route(request)
  
      if route_block
        response = route_block.call(request.params)
        if response.is_a?(Array)
          status, headers, body = response
          Response.build(session, status_code: status, headers: headers, body: body)
        else
          Response.build(session, status_code: 200, body: response)
        end
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
