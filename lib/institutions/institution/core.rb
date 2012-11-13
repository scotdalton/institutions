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
      merge h unless h.nil?
      # If the institution is named default, take that as an
      # indication that it's the default institution
      @default = true if name.downcase.eql? "default"
      # If default was never set, explicitly set default as false.
      @default = false if default.nil?
    end

    # 
    # Sets the required attributes.
    # Raises an ArgumentError specifying the missing arguments if they are nil.
    # 
    def set_required_attributes(code, name)
      missing_arguments = []
      missing_arguments << :code if code.nil?
      missing_arguments << :name if name.nil?
      raise ArgumentError.new("Cannot create the Institution based on the given arguments (:code => #{code.inspect}, :name => #{name.inspect}).\n"+
        "The following arguments cannot be nil: #{missing_arguments.inspect}") unless missing_arguments.empty?
      # Set the instance variables
      @code, @name = code.to_sym, name
    end
    private :set_required_attributes
  end
end