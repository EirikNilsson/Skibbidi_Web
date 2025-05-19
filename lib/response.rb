# frozen_string_literal: true

# Klassen Response ansvarar för att bygga och skicka ett komplett HTTP-svar
# över en öppen session (t.ex. en TCP-socket).
#
# Den genererar HTTP-statusrad, headers och kropp enligt HTTP/1.1-standard.
class Response
  # Bygger och skriver ett HTTP/1.1-svar till sessionen.
  #
  # @param session [IO] En öppen ström (ex. TCP-socket) där svaret skrivs.
  # @param status_code [Integer] HTTP-statuskod, t.ex. 200 eller 404.
  # @param headers [Hash{String => String}] HTTP-headrar som skickas med svaret.
  # @param body [String] Kroppen i svaret, dvs själva innehållet.
  # @param content_type [String] (Ignorerad parameter).
  # @return [void]
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
