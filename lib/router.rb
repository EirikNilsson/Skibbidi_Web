class Router
  def initialize
    @routes = []
  end


  def add_route(method, path, &block)
    regex = Regexp.new("^" + path.gsub(/:\w+/, '([^/]+)') + "$")
    keys = path.scan(/:(\w+)/).flatten
    @routes << { method: method, regex: regex, keys: keys, block: block }
  end
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
