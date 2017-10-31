require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  file_name = nil

  before :each do
    file_name = "#{SecureRandom.uuid}.ext"
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                                              content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
  end

  it 'delete_file' do
    s3.delete_file("test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  it 'delete_file with slash in the beginning of the path line' do
    s3.delete_file("/test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  after :each do
    OnlyofficeFileHelper::FileHelper.delete_directory(s3.download_folder)
  end
end
