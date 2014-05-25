require_relative 'helper'

class TestIf < MiniTest::Test
  include Fragments

  def test_if
    @string_input = <<HERE
    def itest(n)
      if( n < 12)
        putstring("then")
      else
        putstring("else")
      end
    end
    itest(20)
HERE
    @should = [0x0,0xb0,0xa0,0xe3,0x14,0x10,0xa0,0xe3,0x2,0x0,0x0,0xeb,0x1,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x40,0x2d,0xe9,0xc,0x0,0x51,0xe3,0x5,0x0,0x0,0xaa,0x2,0x0,0x2d,0xe9,0x3c,0x10,0x8f,0xe2,0x8,0x20,0xa0,0xe3,0x7,0x0,0x0,0xeb,0x2,0x0,0xbd,0xe8,0x4,0x0,0x0,0xea,0x2,0x0,0x2d,0xe9,0x2c,0x10,0x8f,0xe2,0x8,0x20,0xa0,0xe3,0x1,0x0,0x0,0xeb,0x2,0x0,0xbd,0xe8,0x0,0x80,0xbd,0xe8,0x0,0x40,0x2d,0xe9,0x1,0x0,0xa0,0xe3,0x4,0x70,0xa0,0xe3,0x0,0x0,0x0,0xef,0x0,0x70,0xa0,0xe1,0x0,0x80,0xbd,0xe8,0x74,0x68,0x65,0x6e,0x0,0x0,0x0,0x0,0x65,0x6c,0x73,0x65,0x0,0x0,0x0,0x0]
    parse 
    write "if"
  end
end

