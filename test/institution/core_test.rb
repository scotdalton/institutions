require 'test_helper'

class CoreTest < Test::Unit::TestCase
  def test_new
    hash = { "first" => "My first attribute.", :array_attribute => [1, 2] }
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    }
  end

  def test_new_no_hash
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution")
    }
  end

  def test_new_nil_hash
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution", nil)
    }
  end

  def test_new_nil_code
    assert_raise(ArgumentError) {
      institution = Institutions::Institution.new(nil, "My Institution")
    }
  end

  def test_new_nil_name
    assert_raise(ArgumentError) {
      institution = Institutions::Institution.new("my_inst", nil)
    }
  end
end