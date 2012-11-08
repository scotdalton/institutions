module Institutions#:no_doc
  module Core#:no_doc
    # Required attributes
    attr_reader :code, :name
    alias :display_name :name

    # Optional core attributes
    attr_reader :default
    alias :default? :default

    #
    # Creates a new Institution object from the given code, name and hash.
    #
    # The optional +hash+, if given, will generate additional attributes and values.
    # 
    # 
    # For example:
    #
    #   require 'institutions'
    #   hash = { "attribute1" => "My first attribute.", :array_attribute => [1, 2] }
    #   institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    #
    #   p institution        # -> <Institutions::Institution @code=:my_inst @name="My Institution" @attribute1=My first attribute." @array_attribute=[1, 2] @default=false>
    #
    def initialize(code, name, h={})
      # Set the required attributes
      set_required_attributes code, name
      # Merge in the optional hash attribute
      merge h
      # If the institution is named default, take that as an
      # indication that it's the default institution
      @default = true if (name.eql? "default" or name.eql? "DEFAULT") 
      # If default was never set, explicitly set default as false.
      @default = false if default.nil?
    end

    #
    # Converts the Institution to a hash with keys representing
    # each Institutional attribute (as symbols) and their corresponding values.
    # Example:
    #
    #   require 'institutions'
    #   institution = Institution.new("my_inst", "My Institution")
    #   data.to_hash   # => {:code => "my_inst", :name => "My Institution", :default => false }
    #
    def to_hash
      hash = {}
      instance_variables.each do |instance_variable|
        # Remove beginning '@' and convert to symbol for hash keys.
        hash_key = instance_variable.to_s.sub(/^@/,'').to_sym
        hash[hash_key] = instance_variable_get(instance_variable)
      end
      hash
    end

    # 
    # Dynamically sets attr_readers for elements
    # 
    def method_missing(method, *args, &block)
      instance_variable = instance_variablize(method)
      if instance_variable_defined? instance_variable
        self.class.send :attr_reader, method.to_sym
        instance_variable_get instance_variable
      else
        super
      end
    end

    # 
    # Tells users that we respond to missing methods
    # if they are instance variables.
    # 
    def respond_to_missing?(method, include_private = false)
      if instance_variable_defined? instance_variablize(method)
        true
      else
        super
      end
    end

    # 
    # Sets the required attributes.
    # Raises an ArgumentError specifying the missing arguments if they are nil.
    # 
    def set_required_attributes(code, name)
      missing_arguments = []
      missing_arguments << :code if code.nil?
      missing_arguments << :name if name.nil?
      raise ArgumentError.new("Cannot create the Institution based on the given arguments (#{args.inspect}).\n"+
        "The following arguments cannot be nil: #{missing_arguments.inspect}") unless missing_arguments.empty?
      # Set the instance variables
      @code, @name = code.to_sym, name
    end
    private :set_required_attributes
  end
end