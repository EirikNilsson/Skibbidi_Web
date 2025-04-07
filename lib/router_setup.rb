module AppRoutes
  attr_accessor :router

  def get(path, &block)
    router.add_route('GET', path, &block)
  end

  def post(path, &block)
    router.add_route('POST', path, &block)
  end

  def redirect(location, status: 302)
    [
      status,
      { "Location" => location, "Content-Type" => "text/html" },
      "<html><body>Redirecting to <a href='#{location}'>#{location}</a></body></html>"
    ]
  end
end