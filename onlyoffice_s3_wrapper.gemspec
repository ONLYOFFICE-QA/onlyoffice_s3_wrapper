# frozen_string_literal: true

require_relative 'lib/onlyoffice_s3_wrapper/name'
require_relative 'lib/onlyoffice_s3_wrapper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeS3Wrapper::NAME
  s.version = OnlyofficeS3Wrapper::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 2.5'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Dmitry Rotaty']
  s.summary = 'ONLYOFFICE Helper Gem for S3'
  s.description = 'ONLYOFFICE Helper Gem for S3. Used in QA'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'homepage_uri' => s.homepage,
    'source_code_uri' => s.homepage
  }
  s.email = ['shockwavenn@gmail.com', 'flamine@gmail.com']
  s.files = Dir['lib/**/*']
  s.add_runtime_dependency('aws-sdk-s3', '~> 1')
  s.add_runtime_dependency('onlyoffice_file_helper', '~> 0.1')
  s.add_development_dependency('rake', '~> 13.0')
  s.add_development_dependency('rubocop', '0.90.0')
  s.add_development_dependency('rubocop-performance', '1.8.0')
  s.add_development_dependency('rubocop-rake', '0.5.1')
  s.add_development_dependency('rubocop-rspec', '1.43.2')
  s.add_development_dependency('yard', '0.9.25')
  s.license = 'AGPL-3.0'
end
