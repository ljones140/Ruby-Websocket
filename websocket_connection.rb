class WebSocketConnection

  attr_reader :socket

  def initialize(socket)
    @socket = socket
  end

  def recv
    fin_and_opcode = socket.read(1).bytes[0]
    mask_and_length_indicator = socket.read(1).bytes[0]
    length_indicator = mask_and_length_indicator - 128

    length = if length_indicator <= 125
               length_indicator
             elsif length_indicator == 126
               socket.read(2).unpack("n")[0]
             else
               socket.read(8).unpack("Q>")[0]
             end

    keys = socket.read(4).bytes
    encoded = socket.read(length).bytes

    decoded = encoded.each_with_index.map do |byte, index|
      byte ^ keys[index % 4]
    end

    decoded.pack("c*")
  end

end
