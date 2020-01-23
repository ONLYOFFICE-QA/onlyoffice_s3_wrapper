# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  file_name = nil

  before do
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

  describe 'make_public' do
    let(:make_public_result) do
      OnlyofficeFileHelper::FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
                                                                content: '')
      s3.upload_file("/tmp/#{file_name}", 'test')
      s3.make_public("test/#{file_name}")
    end

    it 'make_public result a link' do
      expect(make_public_result[0]).to be_a(String)
    end

    it 'make_public permissions is READ' do
      expect(make_public_result[1]).to eq('READ')
    end
  end
end
