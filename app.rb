require_relative 'lib/router_setup'
require 'erb'
require 'uri'

$fruits = ['Mango', 'Banan', 'Passionsfrukt', 'Kiwi', 'Apelsin']

class App
  include AppRoutes

  def initialize
    @fruits = $fruits
  end

  def erb(template_path)
    file_path = "#{template_path}.erb"
    template = File.read(file_path)
    ERB.new(template).result(binding)
  end

  def setup_routes(router)
    self.router = router

    get "/" do |params|
      erb("views/index")
    end

    get "/login" do |params|
      erb("views/login")
    end

    get "/:id" do |params|
      @fruit = $fruits[params["id"].to_i] || "Unknown"
      "Frukt: #{@fruit}"
    end

    get "/add/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} + #{num2} = #{num1 + num2}</h1>"
    end

    get "/sub/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} - #{num2} = #{num1 - num2}</h1>"
    end

    get "/mul/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} * #{num2} = #{num1 * num2}</h1>"
    end

    get "/div/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} / #{num2} = #{num1 / num2}</h1>"
    end

    get "/img/:url" do |params|
      url = URI.decode_www_form_component(params["url"])
      "<img src='#{url}'>"
    end

    get "/fileimg/:url" do |params|
      url = params["url"]
      "<img src='#{url}'>"
    end

    get "/files/:splat" do |params|
      file_path = File.join("public/img", params["splat"])
      if File.exist?(file_path)
        content_type = MIME_TYPES[File.extname(file_path)] || "application/octet-stream"
        file_data = File.binread(file_path)
        [200, { "Content-Type" => content_type }, file_data]
      else
        [404, {}, "<h1>404 - Filen finns inte</h1>"]
      end
    end

    get "/fruits/new" do |params|
      erb("views/new")
    end

    get "/fruits/new/:splat" do |params|
      new_fruit = params["splat"]
      $fruits.unshift(new_fruit)
      redirect("/")
    end

    get "/fruits/:id/delete" do |params|
      $fruits.delete(:id)
      redirect("/")
    end

    post "/fruits" do |params|
      new_fruit = params["name"]
      puts new_fruit
      $fruits.unshift(new_fruit)
      redirect("/")
    end

    post "/fruits/delete" do |params|
      fruit_to_delete = params["fruit"]
      $fruits.delete(fruit_to_delete)
      redirect("/")
    end
      
  end
end
