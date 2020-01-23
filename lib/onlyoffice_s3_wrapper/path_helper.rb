# frozen_string_literal: true

module OnlyofficeS3Wrapper
  # Module for method to work with paths
  module PathHelper
    # @param filename [String] name of file to upload
    # @param folder [String] folder to upload file
    # @return [String] correct full path to file
    def bucket_file_path(filename, folder)
      return filename unless folder

      folder = folder.sub('/', '') if folder[0] == '/'
      folder = folder.chop if folder?(folder)
      "#{folder}/#{filename}"
    end
  end
end
