# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper::AmazonS3Wrapper do
  let(:wrapper) { described_class.new }

  it 'AmazonS3Wrapper.read_keys raise correct exception if file not found' do
    expect { wrapper.read_keys('/tmp') }
      .to raise_error(/No key or private key/)
  end
end
