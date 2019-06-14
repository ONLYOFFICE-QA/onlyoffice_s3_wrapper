$LOAD_PATH.unshift File.expand_path('../lib', __FILE__)
require 'onlyoffice_s3_wrapper/version'
Gem::Specification.new do |s|
  s.name = 'onlyoffice_s3_wrapper'
  s.version = OnlyofficeS3Wrapper:: VERSION
  s.platform = Gem::Platform::RUBY
  s.authors = ['ONLYOFFICE', 'Pavel Lobashov', 'Dmitry Rotaty']
  s.summary = 'ONLYOFFICE Helper Gem for S3'
  s.description = 'ONLYOFFICE Helper Gem for S3. Used in QA'
  s.email = ['shockwavenn@gmail.com', 'flamine@gmail.com']
  s.files = `git ls-files lib LICENSE.txt README.md`.split($RS)
  s.homepage = 'https://github.com/onlyoffice-testing-robot/onlyoffice_s3_wrapper'
  s.add_runtime_dependency('aws-sdk', '>= 2', '< 4')
  s.add_runtime_dependency('onlyoffice_file_helper', '~> 0.1')
  s.license = 'AGPL-3.0'
end
