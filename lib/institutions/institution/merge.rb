module Institutions#:no_doc
  module Merge#:no_doc
    # 
    # Merges the given arguments into the Institution.
    # Assumes the argument has a to_hash method
    # 
    def merge(arg={})
      arg.to_hash.each do |key, value|
        if instance_variable_defined? instance_variablize(key)
          deep_merge(instance_variable_get(instance_variablize(key)), value)
        else
          # Set each hash value as an instance variable, but don't overwrite code or name values.
          instance_variable_set(instance_variablize(key), value) unless [:code, :name].include? key.to_sym
        end
      end
    end

    # 
    # Recursively merges Hash and Array objects.
    # 
    def deep_merge(arg1, arg2)
      if arg1.instance_of? Hash
        r = {}
        arg1.merge!(arg2) do |key, oldval, newval|
          r[key] = (oldval.class == newval.class) ? deep_merge(oldval, newval) : newval
        end
      elsif arg1.instance_of? Array
        if arg2.instance_of? Array
          arg1.concat(arg2).uniq!
        else
          arg1 << arg2
        end
      else
        arg2
      end
    end
    private :deep_merge
  end
end