# frozen_string_literal: true

require 'aws-sdk-s3'
require 'open-uri'
require 'securerandom'
require 'onlyoffice_file_helper'
require 'onlyoffice_s3_wrapper/path_helper'
require 'onlyoffice_s3_wrapper/version'

# Namespace for Gem
module OnlyofficeS3Wrapper
  # Class for working with amazon s3
  class AmazonS3Wrapper
    # @return [String] default content type for uploaded files
    DEFAULT_CONTENT_TYPE = 'binary/octet-stream'

    include PathHelper
    attr_accessor :s3, :bucket, :download_folder
    # [String] Amazon key
    attr_writer :access_key_id
    # [String] Amazon secret key
    attr_writer :secret_access_key

    def initialize(bucket_name: 'nct-data-share', region: 'us-west-2')
      read_keys
      Aws.config = { access_key_id: @access_key_id,
                     secret_access_key: @secret_access_key,
                     region: region }
      @s3 = Aws::S3::Resource.new
      @bucket = @s3.bucket(bucket_name)
      @download_folder = Dir.mktmpdir('amazon-s3-downloads')
    end

    # Get files by prefix
    # @param prefix [String] prefix to filter
    # @param field [Symbol] field to get
    # @return [Array<Object>] result set
    def get_files_by_prefix(prefix = nil, field: :key)
      @bucket.objects(prefix: prefix)
             .collect(&field)
             .reject { |file| folder?(file) }
    end

    # param [String] prefix
    # return [Array] of folder names with '/'
    # in end and filenames with fullpath (started ad prefix)
    def get_elements_by_prefix(prefix = nil)
      @bucket.objects(prefix: prefix).collect(&:key)
    end

    # Is string path to folder
    # @param str [String] path
    # @return [True, False]
    def folder?(str)
      str.end_with? '/'
    end

    # Get object by name
    # @param obj_name [String] name of object
    # @return [Object]
    def get_object(obj_name)
      @bucket.object(obj_name)
    end

    # @param file_name [String] path to file in S3 bucket
    # @param download_location [String] path to save file.
    #   Can be full path to file, or just the directory to save
    # @return [String] full path to file
    def download_file_by_name(file_name, download_location = nil)
      object = get_object(file_name)
      temp_location = download_object(object, @download_folder)
      OnlyofficeLoggerHelper.log("Temp downloaded file: #{temp_location}")

      return temp_location unless download_location

      download_location = "#{download_location}/#{File.basename(file_name)}" if File.directory?(download_location)
      FileUtils.mv(temp_location, download_location)
      download_location
    end

    # Download object
    # @param object [Object] to download
    # @param download_folder [String] path to save
    # @return [String] path to downloaded file
    def download_object(object, download_folder = @download_folder)
      file_name = "#{download_folder}/#{File.basename(object.key)}"
      link = object.presigned_url(:get, expires_in: 3600)
      File.open(file_name, 'w') do |f|
        IO.copy_stream(URI.parse(link).open, f)
      end
      file_name
    rescue StandardError => e
      raise("File #{file_name} download failed with: #{e}")
    end

    # Upload file
    # @param file_path [String] file to upload
    # @param upload_folder [String] path to upload
    # @param content_type [String] content type of file to upload
    # @return [nil]
    def upload_file(file_path, upload_folder, content_type = DEFAULT_CONTENT_TYPE)
      path = bucket_file_path(File.basename(file_path),
                              upload_folder)
      @bucket.object(path).upload_file(file_path, content_type: content_type)
    end

    # Make file public
    # @param file_path [String] file to make public
    # @return [Array<String, String>] public url and permissions
    def make_public(file_path)
      @bucket.object(file_path).acl.put(acl: 'public-read')
      permission = @bucket.object(file_path).acl.grants.last.permission
      [@bucket.object(file_path).public_url.to_s, permission]
    end

    # Get permissions for file
    # @param file_path [String] path to file
    # @return [Aws::S3::ObjectAcl] permissions
    def get_permission_by_link(file_path)
      @bucket.object(file_path).acl
    end

    # Upload file/folder and make public
    # @param file_path [String] file to upload
    # @param upload_folder [True, False] is this a folder
    # @param content_type [String] content type of file to upload
    # @return [String] public url
    def upload_file_and_make_public(file_path,
                                    upload_folder = nil,
                                    content_type = nil)
      upload_file(file_path, upload_folder, content_type)
      make_public(bucket_file_path(File.basename(file_path), upload_folder))
      @bucket.object(bucket_file_path(File.basename(file_path),
                                      upload_folder)).public_url
    end

    # Delete file by name
    # @param file_path [String] name of file
    # @return [nil]
    def delete_file(file_path)
      file_path = file_path.sub('/', '') if file_path[0] == '/'
      get_object(file_path).delete
    end

    # Get S3 key and S3 private key
    # @param key_location [String] Path to search for key files
    # @return [nil]
    def read_keys(key_location = "#{Dir.home}/.s3")
      @access_key_id = File.read("#{key_location}/key").strip
      @secret_access_key = File.read("#{key_location}/private_key").strip
    rescue Errno::ENOENT
      raise Errno::ENOENT, "No key or private key found in #{key_location} "\
                           "Please create files #{key_location}/key "\
                           "and #{key_location}/private_key"
    end
  end
end
