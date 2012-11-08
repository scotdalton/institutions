module Institutions#:no_doc
  #
  # = institution.rb: Institution
  #
  # Author:: Scot Dalton
  #
  # An Institution represents an administrative unit and its unique configuration data.
  # Institutions are necessarily abstract and fairly flexible to accomodate the myriad
  # needs of applications. An institution only requires a code and name to be instantiated.
  #
  # == Examples:
  #
  #   require 'institutions'
  #   hash = { "attribute1" => "My first attribute.", :array_attribute => [1, 2] }
  #   institution = Institutions::Institution.new("my_inst", "My Institution", hash)
  #
  #   p institution   # -> #<Institutions::Institution @code=:my_inst, @name="My Institution", @attribute1="My first attribute.", @array_attribute=[1, 2], @default=false>
  # 
  class Institution
    include Core
    include Auth
    include IpAddresses
    include Merge
    include Mvc
    include Parents
    include Services
    include Util
  end
end