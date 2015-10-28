require_relative 'websocket_server'
require_relative 'websocket_connection'

server = WebSocketServer.new

loop do
  Thread.new(server.accept) do |connection|
    puts "Connected"
    while (message = connection.recv)
      puts "Recieved #{message} from client"
      connection.send("Recieved #{message} thanks!")
    end
  end
end
