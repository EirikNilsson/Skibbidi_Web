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
      parse_start_line(header_section.lines.first.strip)
      header_lines = header_section.lines[1..-1].map(&:strip)
      @headers = header_lines.map { |line| split_header(line) }.to_h
      parse_body(body) if body
    end
  
    def parse_start_line(line)
      @method, resource_with_params, @version = line.split(' ')
      @resource, query = resource_with_params.split('?', 2)
      @params = parse_query(query) if query
    end
  
    def split_header(line)
      key, value = line.split(': ', 2)
      [key, value]
    end
  
    def parse_query(query)
      query.split('&').map { |pair| pair.split('=', 2) }.to_h
    end
  
    def parse_body(body)
      body.split('&').map { |pair| pair.split('=', 2) }.to_h.each do |key, value|
        @params[key] = value
      end
    end
  end
  