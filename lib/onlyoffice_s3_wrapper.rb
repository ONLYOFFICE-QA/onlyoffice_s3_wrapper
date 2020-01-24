# frozen_string_literal: true

require 'aws-sdk-s3'
require 'open-uri'
require 'securerandom'
require 'onlyoffice_file_helper'
require 'onlyoffice_s3_wrapper/path_helper'
require 'onlyoffice_s3_wrapper/version'

module OnlyofficeS3Wrapper
  # Class for working with amazon s3
  class AmazonS3Wrapper
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

    def folder?(str)
      str.end_with? '/'
    end

    def get_object(obj_name)
      @bucket.object(obj_name)
    end

    def download_file_by_name(file_name, download_folder = @download_folder)
      object = get_object(file_name)
      download_object(object, download_folder)
      OnlyofficeLoggerHelper.log("Downloaded file with name #{file_name} to "\
                                      "folder #{download_folder}")
    end

    def download_object(object, download_folder = @download_folder)
      link = object.presigned_url(:get, expires_in: 3600)
      OnlyofficeLoggerHelper.log('Try to download object with name '\
                                      "#{object.key} to #{download_folder}")
      File.open("#{download_folder}/#{File.basename(object.key)}", 'w') do |f|
        IO.copy_stream(URI.parse(link).open, f)
      end
      OnlyofficeLoggerHelper.log("File with name #{object.key} successfully "\
                                      "downloaded to folder #{download_folder}")
    rescue StandardError
      raise("File #{object.key} is not found un bucket #{@bucket.name}")
    end

    def upload_file(file_path, upload_folder)
      path = bucket_file_path(File.basename(file_path),
                              upload_folder)
      @bucket.object(path).upload_file(file_path)
    end

    def make_public(file_path)
      @bucket.object(file_path).acl.put(acl: 'public-read')
      permission = @bucket.object(file_path).acl.grants.last.permission
      [@bucket.object(file_path).public_url.to_s, permission]
    end

    def get_permission_by_link(file_path)
      @bucket.object(file_path).acl
    end

    def upload_file_and_make_public(file_path, upload_folder = nil)
      upload_file(file_path, upload_folder)
      make_public(bucket_file_path(File.basename(file_path), upload_folder))
      @bucket.object(bucket_file_path(File.basename(file_path),
                                      upload_folder)).public_url
    end

    def delete_file(file_path)
      file_path = file_path.sub('/', '') if file_path[0] == '/'
      get_object(file_path).delete
    end

    private

    # Get S3 key and S3 private key
    # @return [Array <String>] list of keys
    def read_keys
      return if read_env_keys

      @access_key_id = File.read(Dir.home + '/.s3/key').strip
      @secret_access_key = File.read(Dir.home + '/.s3/private_key').strip
    rescue Errno::ENOENT
      raise Errno::ENOENT, "No key or private key found in #{Dir.home}/.s3/ "\
                           "Please create files #{Dir.home}/.s3/key "\
                           "and #{Dir.home}/.s3/private_key"
    end

    # Read keys from env variables
    def read_env_keys
      return false unless ENV['S3_KEY'] && ENV['S3_PRIVATE_KEY']

      @access_key_id = ENV['S3_KEY']
      @secret_access_key = ENV['S3_PRIVATE_KEY']
    end
  end
end
