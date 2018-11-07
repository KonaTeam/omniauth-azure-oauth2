# -*- encoding: utf-8 -*-
require File.expand_path(File.join('..', 'lib', 'omniauth', 'azure_oauth2', 'version'), __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Mark Nadig"]
  gem.email         = ["mark@nadigs.net"]
  gem.description   = %q{An Windows Azure Active Directory OAuth2 strategy for OmniAuth}
  gem.summary       = %q{An Windows Azure Active Directory OAuth2 strategy for OmniAuth}
  gem.homepage      = "https://github.com/KonaTeam/omniauth-azure-oauth2"

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {spec}/*`.split("\n")
  gem.name          = "omniauth-azure-oauth2"
  gem.require_paths = ["lib"]
  gem.version       = OmniAuth::AzureOauth2::VERSION
  gem.license       = "MIT"

  gem.add_dependency 'omniauth', '~> 1.0'
  gem.add_dependency 'jwt', ['>= 1.0', '< 3.0']

  gem.add_runtime_dependency 'omniauth-oauth2', '~> 1.4'

  gem.add_development_dependency 'rspec', '>= 2.14.0'
  gem.add_development_dependency 'rake'
end
