require 'test_helper'

class InstitutionTest < Test::Unit::TestCase
  def test_class
    assert_kind_of Class, Institutions::Institution
  end
  
  def test_new
    hash = { "attribute1" => "My first attribute.", :array_attribute => [1, 2] }
    institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    p institution
   end
end
