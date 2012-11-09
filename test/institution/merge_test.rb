require 'test_helper'

class MergeTest < Test::Unit::TestCase
  def test_merge
    hash1 = { "string_attribute" => "first string", :nested_hash_attribute => {:h1 => {:h1_2 => "first12"}, 
      :h2 => {:h2_1 => "first21", :h2_2 => "first22"}}, :array_attribute => [1, 2, 4] }
    institution1 = Institutions::Institution.new("first_inst", "First Institution", hash1)
    assert_equal(:first_inst, institution1.code)
    assert_equal("First Institution", institution1.name)
    assert_equal({:h1 => {:h1_2 => "first12"}, :h2 => {:h2_1 => "first21", :h2_2 => "first22"}}, 
      institution1.nested_hash_attribute)
    assert_equal([1,2,4], institution1.array_attribute)
    assert_equal("first string", institution1.string_attribute)
    assert_equal(false, institution1.default)
    hash2 = { "string_attribute" => "second string", :nested_hash_attribute => {:h1 => {:h1_2 => "second12"}, 
      :h2 => {:h2_2 => "second22"}}, :array_attribute => [1, 2, 3], :default => true }
    institution2 = Institutions::Institution.new("second_inst", "Second Institution", hash2)
    assert_equal(:second_inst, institution2.code)
    assert_equal("Second Institution", institution2.name)
    assert_equal({:h1 => {:h1_2 => "second12"}, :h2 => {:h2_2 => "second22"}}, 
      institution2.nested_hash_attribute)
    assert_equal([1,2,3], institution2.array_attribute)
    assert_equal("second string", institution2.string_attribute)
    assert_equal(true, institution2.default)
    institution1.merge(institution2)
    assert_equal(:first_inst, institution1.code)
    assert_equal("First Institution", institution1.name)
    assert_equal({:h1 => {:h1_2 => "second12"}, :h2 => {:h2_1 => "first21", :h2_2 => "second22"}},
      institution1.nested_hash_attribute)
    assert_equal([1,2,3,4], institution1.array_attribute.sort)
    assert_equal("second string", institution1.string_attribute)
    assert_equal(true, institution1.default)
  end
end