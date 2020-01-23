# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  it 'download_object' do
    object = s3.get_object('docx/Book.docx')
    s3.download_object(object)
    expect(File)
      .to exist("#{s3.download_folder}/#{object.key.split('/').last}")
  end

  it 'download_file_by_name' do
    s3.download_file_by_name('docx/Book.docx')
    expect(File).to exist("#{s3.download_folder}/Book.docx")
  end

  it 'download_object for nonexitsing name cause exception' do
    fake_name = 'docx/fake-name.fakeext'
    expect { s3.download_file_by_name(fake_name) }.to raise_error(/not found/)
  end
end
