# frozen_string_literal: true

require 'uri'  # Nödvändig för att dekoda URL-parametrar

# Parses HTTP request strings into their component parts.
class Request
  attr_reader :http_method, :resource, :version, :headers, :params

  def initialize(request_string)
    @headers = {}
    @params = {}
    parse_request(request_string)
  end

  private

  def parse_request(request_string)
    header_section, body = request_string.split("\r\n\r\n", 2)
    parse_start_line_and_headers(header_section)
    parse_body_params(body) if @http_method == "POST"  
  end

  def parse_start_line_and_headers(header_section)
    start_line, *header_lines = header_section.lines.map(&:strip)
    @http_method, resource_with_params, @version = start_line.split(' ')
    @resource, query = resource_with_params.split('?', 2)
    @headers = header_lines.map { |line| line.split(': ', 2) }.to_h
    parse_query_params(query)
  end

  def parse_query_params(query)
    return unless query

    query.split('&').each do |pair|
      key, value = pair.split('=', 2)
      @params[key] = URI.decode_www_form_component(value.to_s) if key
    end
  end

  def parse_body_params(body)
    return unless body && !body.strip.empty?
  
    puts "RAW BODY: #{body.inspect}"
  
    body.split('&').each do |pair|
      key, value = pair.split('=', 2)
      if key
        clean_key = key.strip  
        clean_value = URI.decode_www_form_component(value.to_s).strip
        puts "Parsed Param - Key: #{clean_key.inspect}, Value: #{clean_value.inspect}"
        @params[clean_key] = clean_value
      end
    end
  end
  
  
end
