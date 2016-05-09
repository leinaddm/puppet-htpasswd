source "https://rubygems.org"

puppetversion = ENV.key?('PUPPET_VERSION') ? "= #{ENV['PUPPET_VERSION']}" : ['>= 3.3']

# Use rake ~10 for ruby 1.8.7
if RUBY_VERSION <= '1.8.7'
  gem 'rake', '~> 10.1'
end

gem 'puppet', puppetversion
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'
gem 'facter', '>= 1.7.0'
