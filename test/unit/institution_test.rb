require 'test_helper'

class InstitutionTest < Test::Unit::TestCase
  def test_class
    assert_kind_of Class, Institutions::Institution
  end

  def test_new
    hash = { "first" => "My first attribute.", :array_attribute => [1, 2] }
    assert_nothing_raised {
      institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    }
  end

  def test_parent
    hash = { "first" => "My first attribute.", :array_attribute => [1, 2] }
    institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    parent_hash = { "first" => "parent first", :array_attribute => [1, 2, 3], :inherited_trait => "inherited" }
    parent_institution = Institutions::Institution.new("parent", "My Parent Institution", parent_hash)
    institution.merge_parent(parent_institution)
    assert_equal("My first attribute.", institution.first)
    assert_equal("inherited", institution.inherited_trait)
  end

  def test_merge
    hash = { "first" => "First", :nested_hash_attribute => {:t1 => {:t1_2 => "2t11"}, :t2 => {:t2_1 => "Not Overwritten", :t2_2 => "Test1"}},
      :array_attribute => [1, 2] }
    institution = Institutions::Institution.new("my_inst", "My Institution", hash)
    hash2 = { "first" => "Second", :nested_hash_attribute => {:t1 => {:t1_2 => "2t12"}, :t2 => {:t2_2 => "Test2"}}, 
      :array_attribute => [1, 2, 3], :inherited_trait => "inherited" }
    institution2 = Institutions::Institution.new("merge_inst", "Merged Inst", hash2)
    institution.merge(institution2)
    assert_equal("First", institution.first)
    assert_equal("inherited", institution.inherited_trait)
  end

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