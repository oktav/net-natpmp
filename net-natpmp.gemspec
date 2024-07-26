# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name                  = 'net-natpmp'
  s.version               = '0.1.0'
  s.summary               = 'NAT-PMP client for Ruby'
  s.description           = <<-DESC
    A NAT-PMP client for Ruby.
    This gem allows you to interact with NAT-PMP enabled routers to map ports and get the external IP address.
  DESC
  s.authors               = ['Octavian Vaideanu']
  s.email                 = 'octav@devroot.dev'
  s.files                 = Dir['README.md', 'LICENSE', 'lib/**/*.rb']
  s.platform              = Gem::Platform::RUBY
  s.homepage              = 'https://rubygems.org/gems/net-natpmp'
  s.license               = 'MIT'
  s.required_ruby_version = '>= 3.0'
end
