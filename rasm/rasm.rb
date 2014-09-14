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

  {
      daa: 0x27, das: 0x2F,
      aaa: 0x37, aas: 0x3F,
      nop: 0x90, cbw: 0x98, cwd: 0x99, wait: 0x9B, pushf: 0x9C, popf: 0x9D, sahf: 0x9E, lahf: 0x9F,
      movsb: 0xA4, movsw: 0xA5, cmpsb: 0xA6, cmpsw: 0xA7, stosb: 0xAA, stosw: 0xAB, lodsb: 0xAC, lodsw: 0xAD, scasb: 0xAE, scasw: 0xAF,
      into: 0xCE, iret: 0xCF,
      xlat: 0xD7,
      lock: 0xF0, repnz: 0xF2, repz: 0xF3, hlt: 0xF4, cmc: 0xF5, clc: 0xF8, stc: 0xF9, cli: 0xFA, sti: 0xFB, cld: 0xFC, std: 0xFD
  }.each do|method, code|
    define_method method do
      opcodes << code.to_hex
    end
  end

  [[:inc, 0x40], [:dec, 0x48], [:push, 0x50], [:pop, 0x58]].each do|method, base|
    define_method method do|reg|
      if (index = REG_16.find_index reg).nil?
        map = {
          pop: {
            es: 0x07,
            ss: 0x17,
            ds: 0x1F
          },
          push: {
            es: 0x06,
            ss: 0x16,
            cs: 0x0E,
            ds: 0x1E
          }
        }
        if map[method] && (code = map[method][reg])
          opcodes << code.to_hex
        end
      else
        opcodes << (base + index).to_hex
      end
    end
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
end

RASM.new.instance_eval do
  msg = 'Hello NASM World, A Ruby ASM!'
  nop
  mov :bp, 0x7c15
  mov :ax, 0x01301
  mov :cx, msg.length
  mov :dx, 0x0813
  mov :bx, 0x0c
  nop
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

