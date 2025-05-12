# Modulen AppRoutes ger hjälpmetoder för att definiera HTTP-rutter
# (GET och POST) samt en metod för att skapa HTTP-omdirigeringar.
#
# Den förutsätter att ett `router`-objekt är tillgängligt och kan ta emot rutter.
module AppRoutes
  # @return [Router] Den router som används för att registrera routes.
  attr_accessor :router

  # Registrerar en GET-route.
  #
  # @param path [String] Sökvägen för GET-förfrågan, t.ex. "/users/:id".
  # @yieldparam request [Object] Förfrågan som hanteras när routen matchar.
  # @return [void]
  def get(path, &block)
    router.add_route('GET', path, &block)
  end

  # Registrerar en POST-route.
  #
  # @param path [String] Sökvägen för POST-förfrågan.
  # @yieldparam request [Object] Förfrågan som hanteras när routen matchar.
  # @return [void]
  def post(path, &block)
    router.add_route('POST', path, &block)
  end

  # Returnerar ett omdirigeringssvar enligt Rack-konventionen.
  #
  # @param location [String] URL dit användaren ska omdirigeras.
  # @param status [Integer] HTTP-statuskod, standard är 302.
  # @return [Array(Integer, Hash, String)] Ett Rack-kompatibelt svar.
  def redirect(location, status: 302)
    [
      status,
      { "Location" => location, "Content-Type" => "text/html" },
      "<html><body>Redirecting to <a href='#{location}'>#{location}</a></body></html>"
    ]
  end
end
