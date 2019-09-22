# Behaviour is something that has methods, basically class and modules superclass

# instance_methods is the attribute in the including class that has the methods

module Parfait
  class Behaviour < Object

    attr_reader :instance_type , :instance_methods

    def initialize(type)
      super()
      @instance_methods = List.new
      @instance_type = type
    end

    def methods
      @instance_methods
    end

    def method_names
      names = List.new
      methods.each do |method|
        names.push method.name
      end
      names
    end

    def add_instance_method_for(name , type , frame , body )
      method = Parfait::VoolMethod.new(name , type , frame , body )
      add_instance_method( method )
    end

    def add_instance_method( method )
      raise "not implemented #{method.class} #{method.inspect}" unless method.is_a? VoolMethod
      @instance_methods.push(method)
      method
    end

    def remove_instance_method( method_name )
      found = get_instance_method( method_name )
      found ? methods.delete(found) : false
    end

    def get_instance_method( fname )
      raise "get_instance_method #{fname}.#{fname.class}" unless fname.is_a?(Symbol)
      #if we had a hash this would be easier.  Detect or find would help too
      @instance_methods.find {|m| m.name == fname }
    end

    # get the method and if not found, try superclasses. raise error if not found
    def resolve_method( m_name )
      raise "resolve_method #{m_name}.#{m_name.class}" unless m_name.is_a?(Symbol)
      method = get_instance_method(m_name)
      return method if method
      if( super_class_name && super_class_name != :Object )
        method = @super_class.resolve_method(m_name)
      end
      method
    end

    # adding an instance changes the instance_type to include that variable
    def add_instance_variable( name , type)
      @instance_type = @instance_type.add_instance_variable( name , type )
    end

  end
end
