require 'test_helper'

class UtilTest < Test::Unit::TestCase
  def test_missing_method
    hash = { "an_attr" => "My first attribute.", :some_numbers => [1, 2] }
    institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    assert_nothing_raised {
      institution.an_attr
    }
    assert_equal("My first attribute.", institution.an_attr)
    assert_equal([1, 2], institution.some_numbers)
  end
end