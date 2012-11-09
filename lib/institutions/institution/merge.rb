module Institutions#:no_doc
  module Merge#:no_doc
    # 
    # Merges the given arguments into the Institution.
    # Assumes the argument has a to_hash method
    # 
    def merge(arg={})
      arg.to_hash.each do |key, value|
        next unless valid_instance_variable? key
        instance_variable = instance_variablize(key)
        if instance_variable_defined? instance_variable
          instance_variable_set(instance_variable, deep_merge(instance_variable_get(instance_variable), value))
        else
          writer_method = "#{key}=".to_sym
          if respond_to? writer_method
            send writer_method, value
          else
            next if [:code, :name].include? key.to_sym
            # Set each hash value as an instance variable, but don't overwrite code or name values.
            instance_variable_set(instance_variable, value) 
          end
        end
      end
    end

    # 
    # Recursively merges Hash and Array and any objects that have implemented an add method.
    # 
    def deep_merge(arg1, arg2)
      if arg1.instance_of? Hash
        r = {}
        arg1.merge(arg2) do |key, oldval, newval|
          r[key] = (oldval.class == newval.class) ? 
            ([:code, :name].include? key.to_sym) ?
              oldval : deep_merge(oldval, newval) : newval
        end
      elsif arg1.instance_of? Array
        arg1.concat(arg2).uniq
      elsif arg1.respond_to? :add
        arg1.add arg2
      else
        arg2
      end
    end
    private :deep_merge
  end
end