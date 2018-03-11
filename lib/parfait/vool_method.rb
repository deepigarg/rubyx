module Parfait

  # This represents the method at source code level (sis vool)
  #
  # Type objects are already created for args and locals, but the main attribute
  # is the source, which is a Vool::Statement
  #
  # Classes store VoolMethods, while Types store TypedMethod
  # A Type referes to a Class , but a Class (interface) is implemented by many types
  # as it changes during the course of it's life. Types do not change. Objects have
  # type, and so only indirectly a class.
  #
  class VoolMethod

    attr_reader :name , :args_type , :locals_type , :source

    def initialize(name , args_type , locals_type , source )
      @name , @args_type , @locals_type , @source = name , args_type, locals_type , source
      raise "Name must be symbol" unless name.is_a?(Symbol)
      raise "args_type must be type" unless args_type.is_a?(Parfait::Type)
      raise "locals_type must be type" unless locals_type.is_a?(Parfait::Type)
      raise "source must be vool" unless source.is_a?(Vool::Statement)
    end

    def normalize_source
      @source = yield @source
    end

    def create_parfait_method( type )
      raise "create_method #{type.inspect} is not a Type" unless type.is_a? Parfait::Type
      type.create_method( @name , @args_type )#FIXME, @locals_type)
    end

    def create_tmp
      tmp_name = "tmp_#{@locals_type.instance_length}".to_sym
      @locals_type = @locals_type.add_instance_variable( tmp_name , :Object )
      tmp_name
    end
  end
end