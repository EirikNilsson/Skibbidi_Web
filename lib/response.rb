# frozen_string_literal: true

class Response
    def self.build(session, status_code:, body:, content_type: 'text/html')
      status_message = case status_code
                       when 200 then 'OK'
                       when 404 then 'Not Found'
                       else 'Unknown'
                       end
  
      headers = {
        'Content-Type' => content_type,
        'Content-Length' => body.bytesize
      }
  
      session.print "HTTP/1.1 #{status_code} #{status_message}\r\n"
      headers.each { |key, value| session.print "#{key}: #{value}\r\n" }
      session.print "\r\n"
      session.print body
    end
  end
  