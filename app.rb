require_relative 'lib/router_setup'
require 'erb'

module AppRoutes
  @routes = []

  def self.routes
    @routes
  end

  def self.get(path, &block)
    @routes << { method: 'GET', path: path, block: block }
  end

  def self.post(path, &block)
    @routes << { method: 'POST', path: path, block: block }
  end
end

extend AppRoutes  

@fruits = ['Mango', 'Banan', 'Passionsfrukt', 'Kiwi', 'Apelsin']

def erb(template_path)
  file_path = "#{template_path}.erb"
  template = File.read(file_path)
  ERB.new(template).result(binding)
end

# Definiera alla routrar här:
get "/" do
  erb("views/index")
end

get "/login" do
  erb("views/login")
end

get "/:id" do |params|
  id = params['id'].to_i
  @fruit = $fruits[id] || 'Unknown'
  "Frukt: #{@fruit}"
end

get "/add/:num1/:num2" do |params|
  num1 = params['num1'].to_i
  num2 = params['num2'].to_i
  "<h1>Resultat: #{num1} + #{num2} = #{num1 + num2}</h1>"
end

get "/sub/:num1/:num2" do |params|
  num1 = params['num1'].to_i
  num2 = params['num2'].to_i
  "<h1>Resultat: #{num1} - #{num2} = #{num1 - num2}</h1>"
end

get "/mul/:num1/:num2" do |params|
  num1 = params['num1'].to_i
  num2 = params['num2'].to_i
  "<h1>Resultat: #{num1} * #{num2} = #{num1 * num2}</h1>"
end

get "/div/:num1/:num2" do |params|
  num1 = params['num1'].to_i
  num2 = params['num2'].to_i
  "<h1>Resultat: #{num1} / #{num2} = #{num1 / num2}</h1>"
end

get "/img/:url" do |params|
  url = URI.decode_www_form_component(params['url'])
  "<img src='#{url}'>"
end

get "/fileimg/:url" do |params|
  url = params['url']
  "<img src='#{url}'>"
end

get "/files/:splat" do |params|
  file_path = File.join("public/img", params['splat'])

  if File.exist?(file_path)
    content_type = MIME_TYPES[File.extname(file_path)] || 'application/octet-stream'
    file_data = File.binread(file_path)
    [200, { "Content-Type" => content_type }, file_data]
  else
    [404, {}, "<h1>404 - Filen finns inte</h1>"]
  end
end

get "/fruits/new" do
  erb("views/new")
end

post "/" do |params|
  new_fruit = params['name']
  if new_fruit.nil? && new_fruit.empty?
    erb("views/invalid")
  else
    @fruits.unshift(new_fruit)
    erb("views/index")
  end
end
