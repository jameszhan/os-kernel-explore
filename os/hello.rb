header = ['8CC88ED88EC0E80200EBFEB81E7C89C5B91000B80113BB0C00B200CD10C3'].pack('H*')
content = 'Hello, OS!'

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