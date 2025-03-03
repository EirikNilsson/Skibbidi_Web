require 'socket'
require 'erb'
require 'uri'

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
      @id = params['id'].to_i
      @fruit = $fruits[@id] || 'Unknown'
    end
    @router.add_route('GET', '/add/:num1/:num2') do |params|
      num1 = params['num1'].to_i
      num2 = params['num2'].to_i
      result = num1 + num2
      "<h1>Resultat: #{num1} + #{num2} = #{result}</h1>"
    end
    @router.add_route('GET', '/sub/:num1/:num2') do |params|
      num1 = params['num1'].to_i
      num2 = params['num2'].to_i
      result = num1 - num2
      "<h1>Resultat: #{num1} - #{num2} = #{result}</h1>"
    end
    @router.add_route('GET', '/mul/:num1/:num2') do |params|
      num1 = params['num1'].to_i
      num2 = params['num2'].to_i
      result = num1 * num2
      "<h1>Resultat: #{num1} * #{num2} = #{result}</h1>"
    end
    @router.add_route('GET', '/div/:num1/:num2') do |params|
      num1 = params['num1'].to_i
      num2 = params['num2'].to_i
      result = num1 / num2
      "<h1>Resultat: #{num1} / #{num2} = #{result}</h1>"
    end
    

    @router.add_route('GET', '/img/:url') do |params|
      url = URI.decode_www_form_component(params['url']) 
      "<img src='#{url}'>" 
    end
    #localhost:4567/img/https%3A%2F%2Fupload.wikimedia.org%2Fwikipedia%2Fcommons%2F6%2F6a%2FJavaScript-logo.png

    @router.add_route('POST', '/') do |params|
      @new_fruit = params['name']&.strip 

      if @new_fruit.nil? || @new_fruit.empty?
        erb("views/invalid")  
      else
        erb("views/index")  

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
