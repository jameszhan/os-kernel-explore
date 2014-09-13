open 'hello.bin', 'rb' do|io1|
  open 'hello.img', 'rb' do|io2|
    i = 0
    while d1 = io1.read(8) && d2 = io2.read(8)
      puts "#{'%02d' % i} #{d1.unpack('H*')} #{d2.unpack('H*')}"
      i += 1
    end
  end
end