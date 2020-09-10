# frozen_string_literal: true

require 'spec_helper'

RSpec.describe OnlyofficeS3Wrapper do
  let(:make_public_result) do
    file_name = "#{SecureRandom.uuid}.ext"
    FileHelper.create_file_with_content(file_path: "/tmp/#{file_name}",
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
