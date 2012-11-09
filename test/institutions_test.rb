require 'test_helper'

class InstitutionsTest < Test::Unit::TestCase
  def setup
    # Undo any instance variable settings.
    Institutions.send(:instance_variable_set, :@loadpaths, nil)
    assert_nil(Institutions.send(:instance_variable_get, :@loadpaths))
    Institutions.send(:instance_variable_set, :@filenames, nil)
    assert_nil(Institutions.send(:instance_variable_get, :@filenames))
  end
  
  def test_module
    assert_kind_of Module, Institutions
  end
  
  def test_path
    assert_equal Institutions::DEFAULT_LOADPATHS, Institutions.loadpaths
    Institutions.loadpaths<<"/some/path"
  end
end
