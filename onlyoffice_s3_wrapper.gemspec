# frozen_string_literal: true

require_relative 'lib/onlyoffice_s3_wrapper/name'
require_relative 'lib/onlyoffice_s3_wrapper/version'

Gem::Specification.new do |s|
  s.name = OnlyofficeS3Wrapper::NAME
  s.version = OnlyofficeS3Wrapper::VERSION
  s.platform = Gem::Platform::RUBY
  s.required_ruby_version = '>= 3.0'
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Dmitry Rotaty']
  s.summary = 'ONLYOFFICE Helper Gem for S3'
  s.description = 'ONLYOFFICE Helper Gem for S3. Used in QA'
  s.homepage = "https://github.com/ONLYOFFICE-QA/#{s.name}"
  s.metadata = {
    'bug_tracker_uri' => "#{s.homepage}/issues",
    'changelog_uri' => "#{s.homepage}/blob/master/CHANGELOG.md",
    'documentation_uri' => "https://www.rubydoc.info/gems/#{s.name}",
    'source_code_uri' => s.homepage,
    'rubygems_mfa_required' => 'true'
  }
  s.email = ['shockwavenn@gmail.com', 'flamine@gmail.com']
  s.files = Dir['lib/**/*']
  s.add_dependency('aws-sdk-s3', '~> 1')
  # Until https://github.com/aws/aws-sdk-ruby/issues/2984 is resolved
  s.add_dependency('base64', '~> 0')
  s.add_dependency('onlyoffice_file_helper', '< 3')
  s.license = 'AGPL-3.0-or-later'
end
