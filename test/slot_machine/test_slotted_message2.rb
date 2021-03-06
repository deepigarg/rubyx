require_relative "helper"

module SlotMachine
  class TestSlottedMessage2 < MiniTest::Test
    def setup
      Parfait.boot!(Parfait.default_test_options)
      compiler = Risc.test_compiler
      slotted = SlottedMessage.new([:caller])
      @register = slotted.to_register(compiler , "fake source")
      @instruction = compiler.risc_instructions.next
    end
    def test_def_class
      assert_equal Risc::SlotToReg , @instruction.class
    end
    def test_def_next_class
      assert_equal NilClass , @instruction.next.class
    end
    def test_def_array #from message r0
      assert_equal :message , @instruction.array.symbol
    end
    def test_def_register # to next free register r1
      assert_equal :"message.caller" , @register.symbol
    end
    def test_def_index # at caller index 6
      assert_equal 6 , @instruction.index
    end
  end
end
