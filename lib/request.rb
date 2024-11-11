# frozen_string_literal: true


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
    header_section, body = request_string.split("\n\n", 2)
    parse_start_line_and_headers(header_section)
    parse_query_params
    parse_body_params(body)
  end

  def parse_start_line_and_headers(header_section)
    start_line, *header_lines = header_section.lines.map(&:strip)
    @http_method, resource_with_params, @version = start_line.split(' ')
    @resource, query = resource_with_params.split('?', 2)
    @headers = header_lines.map { |line| line.split(': ', 2) }.to_h
    @params.merge!(query.split('&').map { |pair| pair.split('=', 2) }.to_h) if query
  end

  def parse_query_params
    @parse_query_params ||= {}
  end

  def parse_body_params(body)
    return unless body

    body.split('&').each do |pair|
      key, value = pair.split('=', 2)
      @params[key] = value
    end
  end
end
