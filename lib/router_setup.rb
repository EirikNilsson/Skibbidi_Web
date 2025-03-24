require_relative 'router'

module AppRoutes
  def self.router
    @router ||= Router.new
  end

  def get(path, &block)
    AppRoutes.router.add_route('GET', path, &block)
  end

  def post(path, &block)
    AppRoutes.router.add_route('POST', path, &block)
  end
end
