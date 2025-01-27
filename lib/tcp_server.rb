require 'socket'
require 'erb'
require_relative 'request'
require_relative 'router'
require_relative 'response'

# Global variabel för att lagra frukterna
$fruits = ['Mango', 'Banan', 'Passionsfrukt', 'Kiwi', 'Apelsin']

class HTTPServer

  def erb(template_path)
    file_path = "#{template_path}.erb"       
    template = File.read(file_path)          
    ERB.new(template).result(binding)        
  end

  def initialize(port)
    @port = port
    @router = Router.new

    @router.add_route('GET', '/login') do
      erb("views/login")  
    end

    @router.add_route('GET', '/') do
      erb("views/index")  
    end

    @router.add_route('GET', '/:id') do |params|
      id = params['id'].to_i
      @fruit = $fruits[id] || 'Unknown'
      <<-HTML
      <!DOCTYPE html>
      <html lang="en">
      <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Frukt #{$fruits[id]}</title>
      </head>
      <body>
          <h1>Fruit: #{@fruit}</h1>
          <a href="/">Go Back to Fruit Page</a>
      </body>
      </html>
      HTML
    end

    @router.add_route('POST', '/') do |params|
      @new_fruit = params['name']&.strip 

      if @new_fruit.nil? || @new_fruit.empty?
        <<-HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Error</title>
        </head>
        <body>
            <h1>Invalid input: Please enter a valid fruit name!</h1>
            <a href="/">Go Back to Fruit Page</a>
        </body>
        </html>
        HTML
      else
        $fruits << @new_fruit
        <<-HTML
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Fruit Added</title>
        </head>
        <body>
            <h1>New Fruit Added: #{@new_fruit}</h1>
            <a href="/">Go Back to Fruit Page</a>
        </body>
        </html>
        HTML
      end
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
        html = route_block.call(request.params)
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
