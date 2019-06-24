require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  file_name = nil

  before :each do
    file_name = "#{SecureRandom.uuid}.ext"
  end

  it 'has a version number' do
    expect(OnlyofficeS3Wrapper::VERSION).not_to be nil
  end

  it 'get_object' do
    object = s3.get_object('docx/Book.docx')
    expect(object.key).to eq('docx/Book.docx')
  end

  it 'get_permission_by_link' do
    object = s3.get_permission_by_link('docx/Book.docx')
    expect(object).to be_a(Aws::S3::ObjectAcl)
  end

  it 'make_public' do
    OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                                              content: '')
    s3.upload_file("/tmp/#{file_name}", 'test')
    link, permissions = s3.make_public("test/#{file_name}")
    expect(link.is_a?(String)).to be_truthy
    expect(permissions).to eq('READ')
  end

  after :each do
    OnlyofficeFileHelper::FileHelper.delete_directory(s3.download_folder)
  end
end
