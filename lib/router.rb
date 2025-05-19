# frozen_string_literal: true

# frozen_string_literal: true

# Router hanterar HTTP-routing genom att matcha HTTP-metod och sökväg
# mot definierade rutter och returnera den tillhörande block-funktionen.
class Router
  # Skapar en ny Router-instans.
  def initialize
    @routes = []
  end

  # Lägger till en ny route.
  #
  # @param method [String] HTTP-metod, t.ex. "GET" eller "POST".
  # @param path [String] Sökväg med parametrar, t.ex. "/users/:id".
  # @yieldparam request [Object] Objekt som representerar förfrågan.
  # @return [void]
  def add_route(method, path, &block)
    regex = Regexp.new("^" + path.gsub(/:\w+/, '([^/]+)') + "$")
    keys = path.scan(/:(\w+)/).flatten
    @routes << { method: method, regex: regex, keys: keys, block: block }
  end

  # Försöker matcha en inkommande request mot befintliga routes.
  #
  # Om en matchning sker, extraheras parametrar från sökvägen och
  # tillförs request-objektet. Den matchande block-funktionen returneras.
  #
  # @param request [Object] Objekt med `http_method`, `resource`, och `params`.
  # @return [Proc, nil] Det block som ska exekveras om matchning sker, annars `nil`.
  def match_route(request)
    @routes.each do |route|
      if route[:method] == request.http_method
        match_data = route[:regex].match(request.resource)
        if match_data
          params = {}
          route[:keys].each_with_index do |key, index|
            params[key] = match_data[index + 1]
          end
          request.params.merge!(params)
          return route[:block]
        end
      end
    end
    nil
  end
end
