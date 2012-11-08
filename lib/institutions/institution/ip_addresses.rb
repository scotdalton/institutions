module Institutions
  module IpAddresses
    require 'ipaddr'
    attr_reader :ip_addresses

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
      candidate_ip = IPAddr.new(candidate)
      ip_addresses.each do |ip_address|
        ip_range = (ip_address.match(/[\-\*]/)) ? 
          (ip_address.match(/\-/)) ? 
            (IPAddr.new(ip_address.split("-")[0])..IPAddr.new(ip_address.split("-")[1])) :
              (IPAddr.new(ip_address.gsub(/\*/, "0"))..IPAddr.new(ip_address.gsub(/\*/, "255"))) :
                IPAddr.new(ip_address).to_range
        return true if ip_range === candidate_ip unless ip_range.nil?
      end
      return false;
    end
  end
end