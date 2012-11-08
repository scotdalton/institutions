# Order of paths, then order of files dictates overrides.

module Institutions
  require 'require_all'
  require_rel 'institutions'
  
  # Default paths/files for the module.
  default_loadpaths = ["./config"]
  default_loadpaths << "#{Rails.root}/config" if (defined?(Rails) and Rails.root)
  DEFAULT_LOADPATHS = default_loadpaths
  default_filenames = ["institutions.yml"]
  DEFAULT_FILENAMES = default_filenames
  
  def self.loadpaths
    @loadpaths ||= DEFAULT_LOADPATHS
  end

  def self.filenames
    @filenames ||= DEFAULT_FILENAMES
  end
  
  def self.from_yaml
    unless @institutions
      raise ArgumentError.new("No load path was specified.") if loadpaths.nil?
      loadfiles = []
      loadpaths.each do |loadpath|
        filenames.each do |filename|
          puts filename
          loadfile = File.join(loadpath, filename)
          puts loadfile
          loadfiles<< loadfile if File.exists?(loadfile)
        end
      end
      raise NameError.new("No files named #{filenames} exist to load in the configured load paths, #{loadpaths}. ") if loadfiles.empty?
      @institutions = {}
      loadfiles.each do |loadfile|
        yaml_h = YAML.load_file(loadfile)
        # Loop through institutions in the yaml
        yaml_h.each do |code, elements|
          if(institutions.has_key(code.to_sym))
            # Merge the new elements
            institutions.merge(elements)
          else
            institutions[code.to_sym] << Institution.new(code, elements["name"], elements)
          end
        end
      end
      # Handle inheritance for institutions
      @institutions.each do |key, institution|
        parent_code = institution.parent_code
        institution.merge_parent(@institutions[parent_code]) if parent_code
      end
    end
    return @institutions
  end
end