# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AmazonS3Wrapper, '#other_methods' do
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
end
