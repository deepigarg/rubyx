module RubyX
  # The RubyXCompiler provides the main interface to create binaries, and also
  # give helper functions to create any intermediate layer.
  # Layers are:
  # - ruby , always needed as input, string
  # - vool - intermediate language layer
  # - mom - intermediate machine layer
  # - risc - "last" intermediate machine layer
  # - target - arm or interpreter binary code
  # - binary - "linked" code, everything need to create an elf binary
  #
  #
  # There are methods to go from ruby to any of the layers in the system
  # (mainly for testing). ruby_to_binary creates actual binary code
  # for a given platform.
  # The compiler keeps the vool source as an instance.
  # To compile several sources, more vool can be added, ie ruby_to_vool
  # can be called several times.
  #
  # All other methods come in pairs, one takes ruby source (those are for testing)
  # and the other uses the stored vool source for further processing.
  #
  # Only builtin is loaded, so no runtime , but the compiler
  # can be used to read the runtime and then any other code
  #
  class RubyXCompiler

    attr_reader :vool , :options

    # initialize boots Parfait and Risc (ie load Builin)
    def initialize(options)
      @options = options
      Parfait.boot!(options[:parfait] || {})
      Risc.boot!(options[:risc] || {})
    end

    # The highest level function creates binary code for the given ruby code
    # for the given platform (see Platform). Binary code means that vool/mom/risc
    # are created and then assembled into BinaryCode objects.
    # (no executable is generated, only the binary code and objects needed for a binary)
    #
    # A Linker is returned that may be used to create an elf binay
    #
    # The compiling is done by to_binary
    def ruby_to_binary(ruby , platform)
      ruby_to_vool(ruby)
      to_binary(platform)
    end

    # ruby_to_target creates Target instructions (but does not link)
    #
    # After creating vool, we call to_target
    # Return a Linker
    def ruby_to_target(ruby , platform)
      ruby_to_vool(ruby)
      to_target( platform )
    end

    # ruby_to_risc creates Risc instructions
    #
    # After creating vool, we call to_risc
    # Return a RiscCollection
    def ruby_to_risc(ruby)
      ruby_to_vool(ruby)
      to_risc()
    end

    # Transform the incoming ruby source (string)  to mom
    #
    # The vool is stored using ruby_to_vool,the to_mom is called
    # Return Mom Statement
    def ruby_to_mom(ruby)
      ruby_to_vool(ruby)
      to_mom
    end

    # Process previously stored vool source to binary.
    # Binary code is generated by calling to_risc, then positioning and calling
    # create_binary on the linker. The linker may then be used to creat a binary file.
    # The biary the method name refers to is binary code in memory, or in BinaryCode
    # objects to be precise.
    def to_binary(platform)
      linker = to_target(platform)
      linker.position_all
      linker.create_binary
      linker
    end

    # transform stored vool to target code
    # return a linker
    def to_target(platform)
      raise "No platform given" unless platform
      collection = to_risc
      collection.translate(platform)
    end

    # Process previously stored vool source to risc.
    # return a Risc::RiscCollection , a collection of MethodCompilers
    def to_risc()
      mom = to_mom
      mom.to_risc()
    end

    # return mom for the previously stored vool source.
    def to_mom
      @vool.to_parfait
      @vool.to_mom(nil)
    end

    # ruby_to_vool compiles the ruby to ast, and then to vool
    def ruby_to_vool(ruby_source)
      ruby_tree = Ruby::RubyCompiler.compile( ruby_source )
      unless(@vool)
        @vool = ruby_tree.to_vool
        return @vool
      end
      # TODO: should check if this works with reopening classes
      # or whether we need to unify the vool for a class
      unless(@vool.is_a?(Vool::ScopeStatement))
        @vool = Vool::ScopeStatement.new([@vool])
      end
      @vool << ruby_tree.to_vool
    end

    def load_parfait
      parfait = ["object"]
      parfait.each do |file|
        path = File.expand_path("../../parfait/#{file}.rb",__FILE__)
        ruby_to_vool(File.read(path))
      end
    end

    def self.ruby_to_binary( ruby , options)
      compiler = RubyXCompiler.new(options)
      compiler.load_parfait if options[:load_parfait]
      compiler.ruby_to_vool(ruby)
      compiler.to_binary(options[:platform])
    end
  end
end
