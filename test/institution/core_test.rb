require 'test_helper'

class CoreTest < Test::Unit::TestCase
  def test_new
    hash = { "first" => "My first attribute.", :array_attribute => [1, 2] }
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    }
  end
end