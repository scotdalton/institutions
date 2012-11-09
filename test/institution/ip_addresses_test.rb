require 'test_helper'

class IpAddressesTest < Test::Unit::TestCase
  def setup
    @hash = { "ip_addresses" => ["134.122.0.0-134.122.149.239",
      "134.22.88.*", "134.165.*.*", "134.238.*.*", "134.168.224.0/23"] }
  end
  
  def test_ip_addresses
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution", @hash)
    }
  end
  
  def test_include_ip?
    institution = Institutions::Institution.new("my_inst", "My Institution", @hash)
    assert institution.includes_ip? "134.165.4.1"
    assert institution.includes_ip? "134.168.224.255"
    assert institution.includes_ip? "134.122.21.12"
  end
end