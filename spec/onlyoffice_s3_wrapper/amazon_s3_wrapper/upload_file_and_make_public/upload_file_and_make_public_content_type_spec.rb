# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AmazonS3Wrapper, '#upload_file_and_make_public' do
  let(:file_name) { "#{SecureRandom.uuid}.ext" }

  before do
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                        content: 'TestContent')
  end

  describe 'content_type' do
    it 'default content type for upload is unknown' do
      link = s3.upload_file_and_make_public("/tmp/#{file_name}", 'test')
      expect(URI.parse(link).open.content_type).to eq(described_class::DEFAULT_CONTENT_TYPE)
    end

    it 'if I specify content_type for file it will be correct' do
      content_type = 'image/png'
      link = s3.upload_file_and_make_public("/tmp/#{file_name}", 'test', content_type)
      expect(URI.parse(link).open.content_type).to eq(content_type)
    end
  end
end
