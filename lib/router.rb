class Router
    def initialize
      @routes = {}
    end

    def add_route(path, &block)
      @routes[path] = block
    end

    def match_route(request)
      @routes[request.resource]
    end
  end