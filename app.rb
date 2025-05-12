require_relative 'lib/router_setup'
require_relative 'lib/mime_types'
require 'erb'
require 'uri'

# En global lista med frukter som används i appen
$fruits = ['Mango', 'Banan', 'Passionsfrukt', 'Kiwi', 'Apelsin']

##
# App-klassen innehåller alla routes för webbapplikationen och hanterar rendering av templates.
class App
  include AppRoutes

  ##
  # Initierar appen och sätter instansvariabeln @fruits.
  def initialize
    @fruits = $fruits
  end

  ##
  # Renderar en ERB-mall.
  #
  # @param template_path [String] Sökväg till mallen utan ".erb"
  # @return [String] Renderad HTML
  def erb(template_path)
    file_path = "#{template_path}.erb"
    template = File.read(file_path)
    ERB.new(template).result(binding)
  end

  ##
  # Definierar alla routes i applikationen.
  #
  # @param router [Router] En instans av Router som används för att koppla samman paths och block
  # @return [void]
  def setup_routes(router)
    self.router = router

    # Startsidans vy
    get "/" do |params|
      erb("views/index")
    end

    # Inloggningsvy
    get "/login" do |params|
      erb("views/login")
    end

    # Visa specifik frukt via ID
    get "/:id" do |params|
      @fruit = $fruits[params["id"].to_i] || "Unknown"
      "Frukt: #{@fruit}"
    end

    # Addition
    get "/add/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} + #{num2} = #{num1 + num2}</h1>"
    end

    # Subtraktion
    get "/sub/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} - #{num2} = #{num1 - num2}</h1>"
    end

    # Multiplikation
    get "/mul/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} * #{num2} = #{num1 * num2}</h1>"
    end

    # Division
    get "/div/:num1/:num2" do |params|
      num1 = params["num1"].to_i
      num2 = params["num2"].to_i
      "<h1>Resultat: #{num1} / #{num2} = #{num1 / num2}</h1>"
    end

    # Visa bild från en URL (HTML-escaped)
    get "/img/:url" do |params|
      url = URI.decode_www_form_component(params["url"])
      "<img src='#{url}'>"
    end

    # Visa bild från lokal filväg
    get "/fileimg/:url" do |params|
      url = params["url"]
      "<img src='#{url}'>"
    end

    # Servera en fil från public/img
    get "/files/:splat" do |params|
      file_path = File.join("public/img", params["splat"])
      if File.exist?(file_path)
        content_type = MimeTypes.for(file_path)
        file_data = File.binread(file_path)
        [200, { "Content-Type" => content_type }, file_data]
      else
        [404, {}, "<h1>404 - Filen finns inte</h1>"]
      end
    end

    # Form för att lägga till frukt
    get "/fruits/new" do |params|
      erb("views/new")
    end

    # Lägg till ny frukt via URL-parametern
    get "/fruits/new/:splat" do |params|
      new_fruit = params["splat"]
      $fruits.unshift(new_fruit)
      redirect("/")
    end

    # Ta bort frukt via ID (OBS: fungerar ej korrekt som det står)
    get "/fruits/:id/delete" do |params|
      $fruits.delete(:id) # OBS: detta borde vara $fruits.delete_at(params["id"].to_i)
      redirect("/")
    end

    # Lägg till frukt via POST
    post "/fruits" do |params|
      new_fruit = params["name"]
      puts new_fruit
      $fruits.unshift(new_fruit)
      redirect("/")
    end

    # Ta bort frukt via POST
    post "/fruits/delete" do |params|
      fruit_to_delete = params["fruit"]
      $fruits.delete(fruit_to_delete)
      redirect("/")
    end
  end
end
