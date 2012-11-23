# -*- encoding: utf-8 -*-

Gem::Specification.new do |gem|
  gem.name          = "ace_of_spades"
  gem.version       = "0.0.1.pre"
  gem.authors       = ["Dom Kiva-Meyer"]
  gem.email         = ["hello@domkm.com"]
  gem.description   = "A simple and flexible playing cards library."
  gem.summary       = "A simple and flexible playing cards library."
  gem.homepage      = "https://github.com/domkm/ace_of_spades"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "rspec", "~> 2.11.0"
  gem.add_development_dependency "guard", "~> 1.5.3"
  gem.add_development_dependency "guard-rspec", "~> 2.1.1"
  gem.add_development_dependency "growl"
end
