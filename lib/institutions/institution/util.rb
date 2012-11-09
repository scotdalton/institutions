module Institutions#:no_doc
  module Util#:no_doc
    # 
    # Dynamically sets attr_readers for elements
    # 
    def method_missing(method, *args, &block)
      return super unless respond_to_missing? method
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
      # Short circuit if we have invalid instance variable name
      return super unless valid_instance_variable? method
      if instance_variable_defined? instance_variablize(method)
        true
      else
        super
      end
    end
    
    def valid_instance_variable?(id)
      id.to_sym.id2name.match(/[\@\=\?]/).nil?
    end

    # Convert s to an instance variable
    def instance_variablize(s)
      "@#{s.to_sym.id2name.downcase}".to_sym
    end
    private :instance_variablize
  end
end