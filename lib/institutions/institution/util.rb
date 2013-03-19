module Institutions#:no_doc
  module Util#:no_doc
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
      instance_variables.each do |inst_var|
        hash[hash_keyize(inst_var)] = instance_variable_get(inst_var)
      end
      hash
    end

    # 
    # Dynamically sets attr_readers for elements
    # 
    def method_missing(method, *args, &block)
      instance_variable = instance_variablize(method)
      if respond_to_missing?(method) and instance_variable_defined?(instance_variable)
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
      # Short circuit if we have invalid instance variable name,
      # otherwise we get an exception that we don't need.
      return super unless valid_instance_variable? method
      if instance_variable_defined? instance_variablize(method)
        true
      else
        super
      end
    end
    
    def valid_instance_variable?(id)
      id.to_sym.id2name.match(/[\@\=\?+\[\]]/).nil?
    end

    # Convert s to an instance variable
    def instance_variablize(s)
      "@#{s.to_sym.id2name.downcase}".to_sym
    end
    private :instance_variablize

    # Convert s to a hash key
    def hash_keyize(s)
      # Remove beginning '@' and convert to symbol for hash keys.
      s.to_s.sub(/^@/,'').to_sym
    end
    private :instance_variablize
  end
end