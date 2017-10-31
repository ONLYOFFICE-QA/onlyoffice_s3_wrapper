require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  let(:s3) { OnlyofficeS3Wrapper::AmazonS3Wrapper.new(bucket_name: 'nct-test-bucket', region: 'us-east-1') }
  file_name = nil

  before :each do
    file_name = "#{SecureRandom.uuid}.ext"
  end

  it 'has a version number' do
    expect(OnlyofficeS3Wrapper::VERSION).not_to be nil
  end

  it 'get_files_by_prefix' do
    files = s3.get_files_by_prefix('docx')
    expect(files).to include('docx/Book.docx')
  end

  it 'get_files_by_prefix with sub folder prefix' do
    files = s3.get_files_by_prefix('docx/test_folder')
    expect(files).to include('docx/test_folder/file_in_test_folder.rtf')
  end

  it 'get_files_by_prefix with empty prefix' do
    files = s3.get_files_by_prefix(nil)
    expect(files.size).to be >= 1
  end

  it 'get_files_by_prefix with not exist prefix' do
    files = s3.get_files_by_prefix('notexistprefix')
    expect(files.size).to eq(0)
  end

  it 'get_object' do
    object = s3.get_object('docx/Book.docx')
    expect(object.key).to eq('docx/Book.docx')
  end

  it 'download_object' do
    object = s3.get_object('docx/Book.docx')
    s3.download_object(object)
    expect(File.exist?("#{s3.download_folder}/#{object.key.split('/').last}")).to be_truthy
  end

  it 'download_file_by_name' do
    s3.download_file_by_name('docx/Book.docx')
    expect(File.exist?("#{s3.download_folder}/Book.docx")).to be_truthy
  end

  it 'upload_file' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    expect(s3.get_files_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the beginning of the path line' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", '/test')
    expect(s3.get_elements_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'upload_file with slash in the end of the path line' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test/')
    expect(s3.get_elements_by_prefix('test')).to include("test/#{file_name}")
  end

  it 'delete_file' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    s3.delete_file("test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  it 'delete_file with slash in the beginning of the path line' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    s3.delete_file("/test/#{file_name}")
    expect(s3.get_files_by_prefix('test')).not_to include("test/#{file_name}")
  end

  it 'make_public' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}", content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    link, permissions = s3.make_public("test/#{file_name}")
    expect(link.is_a?(String)).to be_truthy
    expect(permissions).to eq('READ')
  end

  after :each do
    OnlyofficeFileHelper::FileHelper.delete_directory(s3.download_folder)
  end
end
