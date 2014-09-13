header = ['8CC88ED88EC0E80200EBFEB81E7C89C5B91000B80113BB0C00B200CD10C3'].pack('H*')

# mov ax, cs          -> 8CC8
# mov	ds, ax          -> 8ED8
# mov	es, ax          -> 8EC0
# call hello          -> E8 ----   | E8 0200

# jmp $               -> EBFE

# mov	ax, message     -> B8 ----   | B8 1E7C
# mov	bp, ax          -> 89C5
# mov	cx, 10h         -> B9 1000
# mov	ax, 01301h      -> B8 0113
# mov	bx, 000ch       -> BB 0C00
# mov	dl, 0h          -> B2 00
# int	10h             -> CD 10
# ret                 -> C3


content = 'Hello, OS World!'

open 'hello.img', 'wb' do|io|
  io <<  header
  io << content
  len = header.length + content.length
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