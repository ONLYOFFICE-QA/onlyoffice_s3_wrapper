# Change log

## master (unreleased)

### New Features

* `download_file_by_name` return file path
* Add support to specify file download
  location to `download_file_by_name`
* `download_object` raise more detailed error
* Add `markdownlint`-check task in CI

### Changes

* Use GitHub Actions instead of TravisCI
* Drop support of rubies older than 2.5
* Move `gem` homepage to new organization
* Cleanup `gemspec` file
* Fully redone README file

## 0.1.2 (2020-01-24)

* Reformat log while downloading files
* Use `aws-sdk-s3` instead of unified gem
* Files can be uploaded to root of bucket
* Add Rakefile and tasks for releasing gem

## 0.1.1 (2018-02-01)

* Ability to get any field in `get_files_by_prefix`

## 0.1.0 (2017-10-31)

* Initial release of `onlyoffice_s3_wrapper` gem
