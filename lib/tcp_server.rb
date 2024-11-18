require 'socket'

class HTTPServer

    def initialize(port)
        @port = port
    end

    def start
        server = TCPServer.new(@port)
        puts "Listening on #{@port}"
        #router = Router.new
        #router.add_route...

        while session = server.accept
            data = ""
            while line = session.gets and line !~ /^\s*$/
                data += line
            end
            puts "RECEIVED REQUEST"
            puts "-" * 40
            puts data
            puts "-" * 40 

            #request = Request.new(data)
            #router.match_route(request)
            #Sen kolla om resursen (filen finns)


            # Nedanstående bör göras i er Response-klass
            html = <<-HTML
            <!DOCTYPE html>
            <html lang="en">
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Min Snygga Server</title>
                <style>
                    body {
                        font-family: Arial, sans-serif;
                        background-color: #f4f4f9;
                        color: #333;
                        margin: 0;
                        padding: 0;
                    }
                    header {
                        background-color: #007bff;
                        color: white;
                        padding: 20px;
                        text-align: center;
                    }
                    main {
                        padding: 20px;
                        max-width: 800px;
                        margin: 0 auto;
                    }
                    section {
                        margin-bottom: 30px;
                        padding: 20px;
                        background: #fff;
                        border-radius: 8px;
                        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
                    }
                    section h2 {
                        color: #007bff;
                        margin-bottom: 10px;
                    }
                    footer {
                        background-color: #333;
                        color: white;
                        text-align: center;
                        padding-bottom: 20px;
                        padding-top: 20px;
                        width: 100%;
                    }
                    .button {
                        display: inline-block;
                        padding: 10px 20px;
                        font-size: 1em;
                        color: #fff;
                        background-color: #007bff;
                        border: none;
                        border-radius: 5px;
                        text-decoration: none;
                        cursor: pointer;
                        transition: background-color 0.3s ease;
                    }
                    .button:hover {
                        background-color: #0056b3;
                    }
                </style>
            </head>
            <body>
                <header>
                    <h1>Välkommen till min server!</h1>
                    <p>En enkel HTTP-server skriven i Ruby</p>
                </header>
                <main>
                    <section>
                        <h2>Introduktion</h2>
                        <p>Hej! Detta är en server skapad för att testa Ruby och grundläggande webbutveckling.</p>
                        <p>Här kan du se hur servern fungerar och hur den genererar HTML-innehåll direkt.</p>
                    </section>
                    <section>
                        <h2>Hur går det med servern?</h2>
                        <p>Allt ser bra ut! Din server lyssnar och kan skicka svar till klienter.</p>
                        <p>Du kan experimentera med att lägga till fler funktioner och interaktivitet.</p>
                    </section>
                    <section>
                        <h2>Funktioner</h2>
                        <ul>
                            <a href="#" class="button">Lägg till</a>
                            
                        </ul>
                    </section>
                    <section>
                        <h2>Testa igen</h2>
                        <p>Klicka på knappen nedan för att ladda om sidan och se serverns svar igen.</p>
                        <a href="/" class="button">Ladda om</a>
                    </section>
                </main>
                <footer>
                    <p>Skapad av [Eirik Nilsson] - Ruby HTTP Server © 2024</p>
                </footer>
            </body>
            </html>
            HTML

            session.print "HTTP/1.1 200\r\n"
            session.print "Content-Type: text/html\r\n"
            session.print "\r\n"
            session.print html
            session.close
        end
    end
end

server = HTTPServer.new(4567)
server.start