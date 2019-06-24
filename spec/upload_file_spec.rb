# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  file_name = nil

  before :each do
    file_name = "#{SecureRandom.uuid}.ext"
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                                              content: 'TestContent')
  end

  it 'upload_file' do
    s3.upload_file("/tmp/#{file_name}", 'test')
    expect(s3.get_files_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the beginning of the path line' do
    s3.upload_file("/tmp/#{file_name}", '/test')
    expect(s3.get_elements_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the end of the path line' do
    s3.upload_file("/tmp/#{file_name}", 'test/')
    expect(s3.get_elements_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file_and_make_public' do
    link = s3.upload_file_and_make_public("/tmp/#{file_name}", 'test')
    expect(URI.parse(link).open.read).not_to be_empty
  end

  after :each do
    OnlyofficeFileHelper::FileHelper.delete_directory(s3.download_folder)
  end
end
