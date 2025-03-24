require 'socket'
require 'erb'
require 'uri'

require_relative 'request'
require_relative 'router'
require_relative 'response'

$fruits = ['Mango', 'Banan', 'Passionsfrukt', 'Kiwi', 'Apelsin']


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
  BASE_DIR = File.expand_path("../lib/public/img", __dir__)
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

    @router.add_route('GET', '/fileimg/:url') do |params|
      url = params['url']
      "<img src='#{url}'>" 
      puts url
    end

    @router.add_route('GET', '/files/:splat') do |params|
      file_path = File.join(BASE_DIR, params['splat'])
    
      if File.exist?(file_path)
        content_type = get_mime_type(file_path)
        file_data = File.binread(file_path)   
        [200, { "Content-Type" => content_type }, file_data]
      else
        [404, {}, "<h1>404 - Filen finns inte</h1>"]
      end
    end
    
    

    

    @router.add_route('GET', '/fruits/new') do 
      erb("views/new")  
    end

    @router.add_route('POST', '/') do |params|
      puts params.inspect
      @new_fruit = params['name']&.strip
      if @new_fruit.nil? || @new_fruit.empty?
        erb("views/invalid") 
      else
        $fruits.unshift(@new_fruit) 
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
        response = route_block.call(request.params)
        if response.is_a?(Array) 
          status_code, headers, body = response
          Response.build(session, status_code: status_code, headers: headers, body: body)
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