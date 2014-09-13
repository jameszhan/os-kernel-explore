# mov ax, message     -> B8 ----
def mov_ax_opcodes(start_pos)
  ["B8#{start_pos.to_s(16)}7C"].pack('H*')
end

# mov bp, ax          -> 89C5
# mov cx, 10h         -> B9 ----
# mov ax, 01301h      -> B8 0113
# mov bx, 000ch       -> BB 0C00
# mov dl, 0h          -> B2 00
# int 10h             -> CD 10
# nop                 -> 90
def int_10_opcodes(len)
  ["89C5B9#{len.to_s(16)}00B80113BB0C00B200CD1090"].pack('H*')
end

msg = 'Hello, OS World, Thanks!'
int_10 = int_10_opcodes msg.length
start_pos = 3 + int_10.length
mov_ax = mov_ax_opcodes start_pos

open 'hello.img', 'wb' do|io|
  io << mov_ax
  io << int_10
  len = start_pos
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
