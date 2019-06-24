require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  it 'download_object' do
    object = s3.get_object('docx/Book.docx')
    s3.download_object(object)
    expect(File.exist?("#{s3.download_folder}/#{object.key.split('/').last}"))
      .to be_truthy
  end

  it 'download_file_by_name' do
    s3.download_file_by_name('docx/Book.docx')
    expect(File.exist?("#{s3.download_folder}/Book.docx")).to be_truthy
  end

  it 'download_object for nonexitsing name cause exception' do
    fake_name = 'docx/fake-name.fakeext'
    expect { s3.download_file_by_name(fake_name)}.to raise_error(/not found/)
  end

  after :each do
    OnlyofficeFileHelper::FileHelper.delete_directory(s3.download_folder)
  end
end
