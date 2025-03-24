# frozen_string_literal: true


class Response
  def self.build(session, status_code: 200, headers: {}, body: "", content_type: "")
    session.print "HTTP/1.1 #{status_code} OK\r\n"

    headers.each do |key, value|
      session.print "#{key}: #{value}\r\n"
    end

    session.print "Content-Length: #{body.bytesize}\r\n"
    session.print "\r\n"
    session.print body
  end
end
  

  

