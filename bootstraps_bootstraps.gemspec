# -*- encoding: utf-8 -*-
require File.expand_path('../lib/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Robert L. Carpenter"]
  gem.email         = ["codemonkey@robacarp.com"]
  gem.description   = %q{A gem to make working with Bootstrap 2.0 in Rails 3 easier and better.  Includes a new bootstrapped_form replacement for form_for which gives error text handling and html formatting to match Bootstrap's syntax.}
  gem.summary       = %q{Bootstrap 2.0 html helpers for Rails 3}
  gem.homepage      = "https://github.com/robacarp/bootstraps_bootstraps"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.name          = "bootstraps_bootstraps"
  gem.require_paths = ["lib"]
  gem.version       = BootstrapsBootstraps::VERSION
end
