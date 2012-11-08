module Institutions#:no_doc
  module Util#:no_doc
    # Convert s to an instance variable
    def instance_variablize(s)
      "@#{s}".to_sym
    end
    private :instance_variablize
  end
end