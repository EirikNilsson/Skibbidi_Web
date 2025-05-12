# Modulen MimeTypes innehåller logik för att slå upp rätt MIME-typ
# baserat på en fils filändelse. Används t.ex. vid servering av statiska filer.
module MimeTypes
  # En hash som mappar filändelser till MIME-typer.
  #
  # @return [Hash{String => String}]
  TYPES = {
    '.html' => 'text/html',
    '.css'  => 'text/css',
    '.js'   => 'application/javascript',
    '.png'  => 'image/png',
    '.jpg'  => 'image/jpeg',
    '.jpeg' => 'image/jpeg',
    '.gif'  => 'image/gif',
    '.txt'  => 'text/plain'
  }

  # Returnerar MIME-typ baserat på filens ändelse.
  #
  # Om filändelsen inte känns igen returneras "application/octet-stream".
  #
  # @param file_path [String] Sökväg till filen
  # @return [String] MIME-typ som motsvarar filens ändelse
  def self.for(file_path)
    ext = File.extname(file_path).downcase
    TYPES[ext] || 'application/octet-stream'
  end
end
