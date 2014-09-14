class Numeric
  def to_hex
    str = to_s(16)
    str = str.length.even? ? str : "0#{str}"
    str.scan(/[0-9a-f][0-9a-f]?/).reverse.join
  end
end


def display_str_opcodes(base_addr, str_len, row, col, color)
  str =   "BD#{(base_addr + 19).to_hex}"                    # mov bp, ----
  str <<  'B80113'                                          # mov ax, 01301h
  str <<  "B9#{str_len.to_hex}00"                           # mov cx, ----
  str <<  "BA#{col.to_hex}#{row.to_hex}"                    # mov dx, ----
  str <<  "BB#{color.to_hex}00"                             # mov bx, ----
  str <<  'CD10'                                            # int 10h
  str <<  'EBFE'                                            # jmp $
  [str].pack('H*')
end


msg = 'Hello World!'

opcodes = display_str_opcodes(0x7c00, msg.length, 8, 20, 0x0c)

open 'hello.img', 'wb' do|io|
  io << opcodes
  len = opcodes.length
  io << msg
  len += msg.length
  while len < 510
    io << ['00'].pack('H')
    len += 1
  end
  io << ['55AA'].pack('H*')
  len += 2
  while len < 512 * 1440 * 2
    io << ['00'].pack('H')
    len += 1
  end
end


