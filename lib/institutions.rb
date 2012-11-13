# Order of paths, then order of files dictates overrides.

module Institutions
  require 'require_all'
  require_rel 'institutions'

  # Default paths/files for the module.
  DEFAULT_LOADPATH = "./config"
  DEFAULT_FILENAME = "institutions.yml"

  def self.loadpaths
    @loadpaths ||=
      [(defined?(::Rails) and ::Rails.version >= '3.0.1' ) ?
        self.rails_loadpath : DEFAULT_LOADPATH]
  end

  # Necessary to use a proc to generate the rails root a bit later.
  def self.rails_loadpath
    lambda {return "#{Rails.root}/config"}
  end

  def self.filenames
    @filenames ||= [DEFAULT_FILENAME]
  end

  # Intended for internal use only.
  def self.loadfiles
    loadfiles = []
    if loadfiles.empty?
      loadpaths.each do |loadpath|
        filenames.each do |filename|
          loadfile = File.join((loadpath.is_a? Proc) ? loadpath.call : loadpath, filename)
          loadfiles<< loadfile if File.exists?(loadfile)
        end
      end
    end
    loadfiles
  end

  def self.reload
    @institutions = nil
    institutions
  end

  # Returns an Array of Institutions
  def self.defaults
    return institutions.values.find_all { |institution| institution.default? }
  end

  # Returns an Array of Institutions that contain the given IP.
  def self.with_ip(ip)
    return institutions.values.find_all { |institution| institution.includes_ip?(ip) }
  end

  #
  # Returns a Hash of Institution instances with the Institution#code as the Hash key.
  # Load file order can be change by the calling application by using Array methods.
  # The default load file in Rails apps is
  #   "#{Rails.root}/config/institutions.yml"
  # and if not Rails
  #   "./config/institutions.yml"
  # To manipulate load path order and/or add directories to the path
  #   Institutions.loadpaths << File.join("path", "to", "new", "load", "directory")
  # To manipulate file name order and/or add file names
  #   Institutions.filenames << "newfile.yml"
  #
  def self.institutions
    unless @institutions
      raise NameError.new("No load path was specified.") if loadpaths.nil?
      raise NameError.new("No files named #{filenames} exist to load in the configured load paths, #{loadpaths}. ") if filenames.empty?
      @institutions = {}
      loadfiles.each do |loadfile|
        # Loop through institutions in the yaml
        YAML.load_file(loadfile).each_pair do |code, elements|
          code = code.to_sym
          # Merge the new elements or add a new Institution
          @institutions.has_key?(code) ?
            @institutions[code].merge(elements) :
              @institutions[code] =
                Institution.new(code, elements["name"] ? elements["name"] : code.to_s, elements)
        end
      end
      # Handle inheritance for institutions
      merge_parents
    end
    @institutions
  end

  def self.empty?
    institutions.empty?
  end

  def self.institutions?
    (not empty?)
  end

  # Handle inheritance for institutions
  def self.merge_parents
    @institutions.each do |key, institution|
      parent_code = institution.parent_code
      institution.merge_parent(@institutions[parent_code]) if parent_code
    end
  end
end