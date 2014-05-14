module Ast
  # assignment, like operators are really function calls
  
  class CallSiteExpression < Expression
    attr_reader  :name, :args
    def initialize name, args
      @name , @args = name.to_sym , args
    end
    def compile context , into
      params = args.collect{ |a| a.compile(context, into) }
      function = context.program.get_or_create_function(name)
      raise "Forward declaration not implemented (#{name}) #{inspect}" if function == nil
      call = Vm::CallSite.new( name ,  params  , function)
      call.load_args into
      call.do_call into
    end
    
    def inspect
      self.class.name + ".new(" + name.inspect + ", ["+ 
        args.collect{|m| m.inspect }.join( ",") +"] )"  
    end
    def to_s
      "#{name}(" + args.join(",") + ")"
    end
    def attributes
      [:name , :args]
    end
  end
  
end