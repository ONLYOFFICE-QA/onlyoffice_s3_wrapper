# frozen_string_literal: true

require 'spec_helper'

RSpec.describe AmazonS3Wrapper, '#get_files' do
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

  it 'get_files_by_prefix with collect not name' do
    files = s3.get_files_by_prefix('docx/test_folder', field: :public_url)
    expect(files.first).to start_with('http')
  end
end
