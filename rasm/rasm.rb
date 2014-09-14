class Numeric
  def to_hex(fixed_length=0)
    str = to_s(16)
    str = str.length.even? ? str : "0#{str}"
    str = '0' * (fixed_length - str.length) + str if str.length < fixed_length
    str.scan(/[0-9a-f][0-9a-f]?/).reverse.join
  end
end

class RASM
  REG_8   = [:al, :cl, :dl, :bl, :ah, :ch, :dh, :bl]
  REG_16  = [:ax, :cx, :dx, :bx, :sp, :bp, :si, :di]
  REG_COMMON = REG_8 + REG_16

  def initialize
    yield self if block_given?
  end

  def opcodes
    @opcodes ||= ''
  end

  def mov(target, source)
    base, index = 0xB0, REG_COMMON.find_index(target)
    if index
      opcodes << (base + index).to_hex
      if index < 8 && source > 255 || source > 65535
        raise StandardError.new("For register #{target}, #{source} is overflow.")
      end
    else
      raise StandardError.new(:illegal_register)
    end
    opcodes << source.to_hex(index < 8 ? 2 : 4)
  end

  def int(no)
    opcodes << 'CD'
    opcodes << no.to_hex
  end

  def jmp(addr)
    if addr < 256
      opcodes << 'EB'
      opcodes << addr.to_hex
    elsif addr < 65536
      opcodes << 'E9'
      opcodes < addr.to_hex(4)
    else
      opcodes << 'EA'
      opcodes << addr.to_hex(8)
    end
  end

  def nop()
    opcodes << '90'
  end

  def lock()
    opcodes << 'F0'
  end

end

RASM.new.instance_eval do
  msg = 'Hello NASM World, A Ruby ASM!'

  mov :bp, 0x7c13
  mov :ax, 0x01301
  mov :cx, msg.length
  mov :dx, 0x0813
  mov :bx, 0x0c
  int 0x10
  jmp 0xFE

  codes = [opcodes].pack('H*')
  open 'rasm.img', 'wb' do|io|
    io << codes
    len = codes.length
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
end

