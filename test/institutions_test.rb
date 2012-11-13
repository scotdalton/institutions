require 'test_helper'

class InstitutionsTest < Test::Unit::TestCase
  def setup
    # Undo any instance variable settings.
    Institutions.send(:instance_variable_set, :@loadpaths, nil)
    assert_equal([Institutions::DEFAULT_LOADPATH], Institutions.loadpaths)
    Institutions.send(:instance_variable_set, :@filenames, nil)
    assert_equal([Institutions::DEFAULT_FILENAME], Institutions.filenames)
    Institutions.send(:instance_variable_set, :@institutions, nil)
    assert_nil(Institutions.send(:instance_variable_get, :@institutions))
  end
  
  def test_module
    assert_kind_of Module, Institutions
  end
  
  def test_path
    assert_equal [Institutions::DEFAULT_LOADPATH], Institutions.loadpaths
    Institutions.loadpaths << File.join("../config")
    assert_equal [Institutions::DEFAULT_LOADPATH, "../config"], Institutions.loadpaths
  end
  
  def test_institutions
    Institutions.loadpaths << File.join("test", "config")
    institutions = Institutions.institutions
  end
  
  def test_institutions_overwrite
    Institutions.loadpaths << File.join("test", "config")
    Institutions.filenames << "overwrite.yml"
    institutions = Institutions.institutions
    assert_equal "ns", institutions[:NS].views["dir"]
    assert_equal "ns tag", institutions[:NS].views["tag"]
  end
  
  def test_institutions_parents
    Institutions.loadpaths << File.join("test", "config")
    institutions = Institutions.institutions
    assert_equal "NYU Libraries", institutions[:NYU].name
  end
end
