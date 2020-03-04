# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper, '#download_object' do
  let(:s3_file) { 'docx/Book.docx' }

  it 'download_object' do
    object = s3.get_object(s3_file)
    s3.download_object(object)
    expect(File)
      .to exist("#{s3.download_folder}/#{object.key.split('/').last}")
  end
end
