# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AmazonS3Wrapper, '#files_from_folder' do
  before do
    file_name = "#{SecureRandom.uuid}.ext"
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                        content: '')
    s3.upload_file("/tmp/#{file_name}", 'folder')
    s3.upload_file("/tmp/#{file_name}", 'folder_with_suffix')
  end

  it 'get_files_by_prefix will return files from folder with same prefix' do
    files = s3.get_files_by_prefix('folder')
    expect(files.select { |file| file.start_with?('folder_with_suffix/') }).not_to be_empty
  end

  it 'files_from_folder will not return files from folder with same prefix' do
    files = s3.files_from_folder('folder')
    expect(files.select { |file| file.start_with?('folder_with_suffix/') }).to be_empty
  end
end
