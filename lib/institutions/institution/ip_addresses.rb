module Institutions#:no_doc
  module IpAddresses#:no_doc
    require 'ipaddr_range_set'
    attr_reader :ip_addresses
    
    def ip_addresses=(args)
      args.collect! do |arg|
        arg.match(/-/) ? convert_to_range(arg) : arg
      end
      @ip_addresses = IPAddrRangeSet.new(*args)
    end
    protected :ip_addresses=
    
    def ip_addresses_add(arg1, arg2)
      arg1.add(arg2)
    end
    protected :ip_addresses_add
    
    def convert_to_range(s)
      s.split("-")[0]...s.split("-")[1]
    end
    private :convert_to_range

    #
    # Returns a +boolean+ indicating whether the candidate IP 
    # address is in the Institution's IP range.
    # Example:
    #
    #   require 'institutions'
    #   institution = Institution.new("my_inst", "My Institution", "ip_addresses" => ["127.0.0.1", 127.0.0.2"])
    #   data.includes_ip?("127.0.0.1")   # => true
    #   data.includes_ip?("127.0.0.3")   # => false
    # 
    def includes_ip?(candidate)
      return false if ip_addresses.nil?
      return ip_addresses.include? candidate
    end
  end
end