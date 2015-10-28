require_relative 'websocket_server'
require_relative 'websocket_connection'

server = WebSocketServer.new

loop do
  Thread.new(server.accept) do |connection|
    puts "Connected"
    while (message = connection.recv)
      puts message
    end
  end
end
