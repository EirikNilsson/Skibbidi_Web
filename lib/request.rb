

class Request
  attr_reader :method, :resource, :version, :headers, :params

  def initialize(request_string)
    @headers = {}
    @params = {}
    parse_request(request_string)
  end

  private

  def parse_request(request_string)
    header_section, body = request_string.split("\n\n", 2)
    start_line, *header_lines = header_section.lines.map(&:strip)
    @method, resource_with_params, @version = start_line.split(' ')
    @resource, query = resource_with_params.split('?', 2)
    @headers = header_lines.map { |line| line.split(': ', 2) }.to_h
    @params.merge!(query.split('&').map { |pair| pair.split('=', 2) }.to_h) if query
    if body
      body.split('&').each do |pair|
        key, value = pair.split('=', 2)
        @params[key] = value
      end
    end
  end
end
