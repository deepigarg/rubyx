require_relative 'helper'

class TestRecursinveFibo < MiniTest::Test
  include Fragments

  def test_recursive_fibo
    @string_input = <<HERE
class Object
  int fibonaccir( int n )
    if_plus( n - 1 )
      int tmp
      tmp = n - 1
      int a = fibonaccir( tmp )
      tmp = n - 2
      int b = fibonaccir( tmp )
      return a + b
    else
      return n
    end
  end
  int fib_print(int n)
    int fib = fibonaccir( n )
    fib.putint()
  end
  int main()
    fib_print(10)
  end
end
HERE
  @length = 6594
  check
  assert_equal Parfait::Message , @interpreter.get_register(:r1).class
#TODO, works in the gui??  assert_equal 55 , @interpreter.get_register(:r1).return_value
  end
end
