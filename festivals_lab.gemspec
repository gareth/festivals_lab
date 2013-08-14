# -*- encoding: utf-8 -*-
require File.expand_path('../lib/festivals_lab/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Gareth Adams"]
  gem.email         = ["g@rethada.ms"]
  gem.description   = %q{Accesses festival data from the Edinburgh Festivals Innovation Lab API}
  gem.summary       = %q{The Edinburgh Festivals API is an ambitious project which aims to create open access to the event listings data of Edinburgh’s 12 major Festivals}
  gem.homepage      = "https://github.com/gareth/festivals_lab"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "festivals_lab"
  gem.require_paths = ["lib"]
  gem.version       = FestivalsLab::VERSION

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'webmock'
  gem.add_development_dependency 'minitest-reporters'
end
