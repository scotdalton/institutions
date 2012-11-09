module Institutions#:no_doc
  module Merge#:no_doc
    #
    # Merges the given arguments into the Institution.
    # Internally uses a "recursive merge" algorithm to
    # preserve as much of the original Institution as possible.
    # Assumes the argument has a to_hash method
    # Example.
    #
    #   require 'institutions'
    #   hash1 = { "string_attribute" => "first string",
    #             :nested_hash_attribute => {
    #               :h1 => {:h1_2 => "first12"},
    #               :h2 => {:h2_1 => "first21", :h2_2 => "first22"}},
    #             :array_attribute => [1, 2, 4] }
    #   institution1 = Institutions::Institution.new("first_inst", "First Institution", hash1)
    #   p institution1        # -> #<Institutions::Institution @code=:first_inst, @name="First Institution", @array_attribute=[1, 2, 4], @default=false, @string_attribute="first string", @nested_hash_attribute={:h1=>{:h1_2=>"first12"}, :h2=>{:h2_1=>"first21", :h2_2=>"first22"}}>
    #   hash2 = { "string_attribute" => "second string",
    #             :nested_hash_attribute => {:h1 => {
    #               :h1_2 => "second12"},
    #               :h2 => {:h2_2 => "second22"}},
    #             :array_attribute => [1, 2, 3], :default => true }
    #   institution2 = Institutions::Institution.new("second_inst", "Second Institution", hash2)
    #   p institution2        # -> <Institutions::Institution @code=:second_inst, @name="Second Institution", @array_attribute=[1, 2, 3], @default=true, @string_attribute="second string", @nested_hash_attribute={:h1=>{:h1_2=>"second12"}, :h2=>{:h2_2=>"second22"}}>
    #   institution1.merge(institution2)
    #   p institution1        # -> #<Institutions::Institution @code=:first_inst, @name="First Institution", @array_attribute=[1, 2, 4, 3], @default=true, @string_attribute="second string", @nested_hash_attribute={:h1=>{:h1_2=>"second12"}, :h2=>{:h2_1=>"first21", :h2_2=>"second22"}}>
    #
    def merge(arg={})
      arg.to_hash.each do |key, value|
        next unless valid_instance_variable? key
        instance_variable = instance_variablize(key)
        if instance_variable_defined? instance_variable
          instance_variable_set(instance_variable, deep_merge(instance_variable_get(instance_variable), value, key))
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
    # Recursively merges Hash (or any Object that can be converted to a Hash),
    # Array and attributes that have implemented an :attribute_add method.
    #
    def deep_merge(arg1, arg2, key=nil)
      # Attempt deep merge if the two arguments are
      # instances of the same class.
      if arg1.class == arg2.class
        # Preserve arg1's :code and :name.
        if (not key.nil?) and [:code, :name].include? key.to_sym
          return arg1
        # Recursively call deep merge for Hash objects.
        elsif arg1.respond_to? :to_hash
          r = {}
          return arg1.to_hash.merge(arg2.to_hash) do |key, oldval, newval|
            r[key] = deep_merge(oldval, newval, key)
          end
        # Concatenate Arrays and return uniq elements.
        elsif arg1.instance_of? Array
          return arg1.concat(arg2).uniq
        # If Institutions responds to the :key_add method,
        # go ahead and use that to add the Objects together.
        elsif respond_to? "#{key}_add".to_sym
          return send "#{key}_add".to_sym, arg1, arg2
        end
      end
      # NOTE: Commenting this out since I'm not sure this is desirable functionality.
      # If the two args aren't the same class, but arg1 is
      # Array, append arg2 to arg1.
      # if arg1.instance_of? Array
      #   return arg1.dup<<arg2
      # end
      # We tried.
      # If all else fails just replace arg1 with arg2.
      return arg2
    end
    protected :deep_merge
  end
end