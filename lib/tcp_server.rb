require 'socket'
require 'erb'
require 'uri'

require_relative 'request'
require_relative 'response'
require_relative 'router'
require_relative 'router_setup'
require_relative 'mime_types' 
require_relative 'C:\Users\eirik.haugennilsson\Desktop\Programering 2\Skibbidi\app.rb'

##
# HTTPServer är en enkel webserver som hanterar HTTP-förfrågningar
# och levererar dynamiskt eller statiskt innehåll.
class HTTPServer
  # Grundkatalogen för statiska filer
  BASE_DIR = File.expand_path("../public", __dir__) 

  ##
  # Renderar en ERB-mall.
  #
  # @param template_path [String] Sökväg till mallen utan .erb
  # @return [String] Renderad HTML-sträng
  def erb(template_path)
    file_path = "#{template_path}.erb"
    template = File.read(file_path)
    ERB.new(template).result(binding)
  end

  ##
  # Initierar en ny instans av HTTPServer.
  #
  # @param port [Integer] Portnummer att lyssna på
  def initialize(port)
    @port = port
    @router = Router.new
    App.new.setup_routes(@router)
  end

  ##
  # Startar servern och lyssnar efter inkommande anslutningar.
  # Behandlar varje HTTP-förfrågan och skickar ett svar.
  #
  # @return [void]
  def start
    server = TCPServer.new(@port)
    puts "Listening on port #{@port}"

    while session = server.accept
      data = ""

      # Läs headers
      while (line = session.gets) && (line !~ /^\s*$/)
        data += line
      end

      headers = data.split("\r\n")
      content_length = headers.find { |h| h =~ /Content-Length:/i }
      body = ""

      # Läs body om Content-Length finns
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
        # Försök att leverera statisk fil
        file_path = File.join(BASE_DIR, request.path)
        file_path = File.expand_path(file_path)

        if file_path.start_with?(BASE_DIR) && File.file?(file_path)
          content = File.binread(file_path)
          content_type = MimeTypes.for(file_path)
          Response.build(session, status_code: 200, headers: { 'Content-Type' => content_type }, body: content)
        else
          html = "<html><body><h1>404 Not Found</h1></body></html>"
          Response.build(session, status_code: 404, body: html)
        end
      end

      session.close
    end
  end
end

# Skapar och startar servern på port 4567
server = HTTPServer.new(4567)
server.start

