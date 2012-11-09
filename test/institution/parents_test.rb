require 'test_helper'

class ParentsTest < Test::Unit::TestCase
  def test_parent
    hash = { "first" => "My first attribute.", :array_attribute => [1, 2] }
    institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    parent_hash = { "first" => "parent first", :array_attribute => [1, 2, 3], :inherited_trait => "inherited" }
    parent_institution = Institutions::Institution.new("parent", "My Parent Institution", parent_hash)
    institution.merge_parent(parent_institution)
    assert_equal("My first attribute.", institution.first)
    assert_equal("inherited", institution.inherited_trait)
  end
end