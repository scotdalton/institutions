module Institutions#:no_doc
  module Parents#:no_doc
    # Parents attributes
    attr_reader :parent_code
    
    # 
    # Merges the given parent into the Institution.
    # Assumes the parent has a to_hash method
    # 
    def merge_parent(parent={})
      # Use the parent as the base and merge in the current institution
      merge(deep_merge(parent.to_hash, to_hash))
    end
  end
end