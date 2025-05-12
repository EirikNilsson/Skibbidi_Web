# frozen_string_literal: true

require 'uri'

# Klassen Request tolkar en rå HTTP-förfrågan och extraherar
# metainformation såsom metod, resurs, HTTP-version, headers och parametrar.
#
# Den hanterar både query string-parametrar (GET) och body-parametrar (POST).
class Request
  # @return [String] HTTP-metoden, t.ex. "GET" eller "POST"
  attr_reader :http_method

  # @return [String] Resurssökvägen utan query string, t.ex. "/users"
  attr_reader :resource

  # @return [String] HTTP-version, t.ex. "HTTP/1.1"
  attr_reader :version

  # @return [Hash{String => String}] HTTP-headrar
  attr_reader :headers

  # @return [Hash{String => String}] Samlade parametrar från query och body
  attr_reader :params

  # Skapar en Request-instans och tolkar en rå HTTP-förfrågan.
  #
  # @param request_string [String] Den råa HTTP-förfrågan som sträng
  def initialize(request_string)
    @headers = {}
    @params = {}
    parse_request(request_string)
  end

  private

  # Delar upp förfrågan i headers och body, och parsar dessa.
  #
  # @param request_string [String]
  # @return [void]
  def parse_request(request_string)
    header_section, body = request_string.split("\r\n\r\n", 2)
    parse_start_line_and_headers(header_section)
    parse_body_params(body) if @http_method == "POST"
  end

  # Extraherar metod, resurs, version och headers.
  #
  # @param header_section [String] Del av förfrågan som innehåller startlinje och headers
  # @return [void]
  def parse_start_line_and_headers(header_section)
    start_line, *header_lines = header_section.lines.map(&:strip)
    @http_method, resource_with_params, @version = start_line.split(' ')
    @resource, query = resource_with_params.split('?', 2)
    @headers = header_lines.map { |line| line.split(': ', 2) }.to_h
    parse_query_params(query)
  end

  # Tolkar query string-parametrar från URL:en.
  #
  # @param query [String, nil] Query-delen från URL:en
  # @return [void]
  def parse_query_params(query)
    return unless query

    query.split('&').each do |pair|
      key, value = pair.split('=', 2)
      @params[key] = URI.decode_www_form_component(value.to_s) if key
    end
  end

  # Tolkar formdata-parametrar från en POST-body.
  #
  # @param body [String, nil] Body-delen från förfrågan
  # @return [void]
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
