# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'simplecov'
SimpleCov.start do
  enable_coverage :branch
end

require 'onlyoffice_s3_wrapper'
require 'open-uri'

shared_context 'with cleanup download folder' do
  after do
    FileHelper.delete_directory(s3.download_folder)
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.include_context('with cleanup download folder')
  include OnlyofficeFileHelper
  include OnlyofficeS3Wrapper
end

# @return [AmazonS3Wrapper] test bucket
def s3
  @s3 ||= AmazonS3Wrapper.new(bucket_name: 'onlyoffice-s3-wrapper-rspec',
                              region: 'us-east-1')
end
