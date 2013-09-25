$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "institutions/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "institutions"
  s.version     = Institutions::VERSION
  s.authors     = ["Scot Dalton"]
  s.email       = ["scotdalton@gmail.com"]
  s.homepage    = "https://github.com/scotdalton/institutions"
  s.summary     = "Abstract mechanism for setting up Institutions (whatever that means)."
  s.description = "Abstract mechanism for setting up Institutions with arbitrary data elements."

  s.files         = `git ls-files`.split($\)
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})

  s.add_dependency "require_all", "~> 1.3.1"
  s.add_dependency "ipaddr_range_set", "~> 0.10.0"
  s.add_dependency "git", "~> 1.2.6"
  s.add_dependency "rake", "~> 10.1.0"
end
