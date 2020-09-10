# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper, '#download_file_by_name' do
  let(:s3_file) { 'docx/Book.docx' }

  it 'download_file_by_name' do
    s3.download_file_by_name(s3_file)
    expect(File).to exist("#{s3.download_folder}/Book.docx")
  end

  it 'download_file_by_name return result file path' do
    file = s3.download_file_by_name(s3_file)
    expect(File).to exist(file)
  end

  it 'download_object for nonexitsing name cause exception' do
    fake_name = 'docx/fake-name.fakeext'
    expect { s3.download_file_by_name(fake_name) }
      .to raise_error(/download failed.*Not Found/)
  end

  it 'download_file_by_name to custom folder is correct' do
    custom_folder = Dir.mktmpdir('s3_download')
    file = s3.download_file_by_name(s3_file, custom_folder)
    expect(File).to exist(file)
  end

  it 'download_file_by_name as custom file name is correct' do
    custom_name = "#{Dir.mktmpdir('s3_download')}/custom_name"
    file = s3.download_file_by_name(s3_file, custom_name)
    expect(File).to exist(file)
  end
end
