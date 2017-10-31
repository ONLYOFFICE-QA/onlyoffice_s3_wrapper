require 'aws-sdk'
require 'open-uri'
require 'securerandom'
require 'onlyoffice_file_helper'
require 'onlyoffice_s3_wrapper/version'

module OnlyofficeS3Wrapper
  # Class for working with amazon s3
  class AmazonS3Wrapper
    attr_accessor :s3, :bucket, :download_folder, :access_key_id, :secret_access_key

    def initialize(bucket_name: 'nct-data-share', region: 'us-west-2')
      @access_key_id = ENV['S3_KEY']
      @secret_access_key = ENV['S3_PRIVATE_KEY']
      if @access_key_id.nil? || @secret_access_key.nil?
        begin
          @access_key_id = File.read(Dir.home + '/.s3/key').delete("\n")
          @secret_access_key = File.read(Dir.home + '/.s3/private_key').delete("\n")
        rescue Errno::ENOENT
          raise Errno::ENOENT, "No key or private key found in #{Dir.home}/.s3/ directory. Please create files #{Dir.home}/.s3/key and #{Dir.home}/.s3/private_key"
        end
      end
      Aws.config = { access_key_id: @access_key_id,
                     secret_access_key: @secret_access_key,
                     region: region }
      @s3 = Aws::S3::Resource.new
      @bucket = @s3.bucket(bucket_name)
      @download_folder = Dir.mktmpdir('amazon-s3-downloads')
    end

    def get_files_by_prefix(prefix = nil)
      @bucket.objects(prefix: prefix).collect(&:key).reject { |file| is_folder?(file) }
    end

    # param [String] prefix
    # return [Array] of folder names with '/' in end and filenames with fullpath (started ad prefix)
    def get_elements_by_prefix(prefix = nil)
      @bucket.objects(prefix: prefix).collect(&:key)
    end

    def is_folder?(str)
      str.end_with? '/'
    end

    def get_object(obj_name)
      @bucket.object(obj_name)
    end

    def download_file_by_name(file_name, download_folder = @download_folder)
      OnlyofficeLoggerHelper.log("Download file with name #{file_name} to folder #{download_folder}")
      OnlyofficeLoggerHelper.log('Try to find file:')
      object = get_object(file_name)
      download_object(object, download_folder)
    end

    def download_object(object, download_folder = @download_folder)
      link = object.presigned_url(:get, expires_in: 3600)
      OnlyofficeLoggerHelper.log("Try to download object with name #{object.key} to folder #{download_folder}")
      File.open("#{download_folder}/#{File.basename(object.key)}", 'w') do |f|
        IO.copy_stream(open(link), f)
      end
      OnlyofficeLoggerHelper.log("File with name #{object.key} successfully downloaded to folder #{download_folder}")
    rescue StandardError
      raise("File with name #{object.key} is not found un bucket #{@bucket.name}")
    end

    def upload_file(file_path, upload_folder)
      upload_folder.sub!('/', '') if upload_folder[0] == '/'
      upload_folder.chop! if is_folder?(upload_folder)
      @bucket.object("#{upload_folder}/#{File.basename(file_path)}").upload_file(file_path)
    end

    def make_public(file_path)
      @bucket.object(file_path).acl.put(acl: 'public-read')
      permission = @bucket.object(file_path).acl.grants.last.permission
      [@bucket.object(file_path).public_url.to_s, permission]
    end

    def get_permission_by_link(file_path)
      @bucket.object(file_path).acl
    end

    def upload_file_and_make_public(file_path, upload_folder)
      upload_file(file_path, upload_folder)
      make_public("#{upload_folder}/#{File.basename(file_path)}")
      @bucket.object("#{upload_folder}/#{File.basename(file_path)}").public_url
    end

    def delete_file(file_path)
      file_path.sub!('/', '') if file_path[0] == '/'
      get_object(file_path).delete
    end
  end
end
