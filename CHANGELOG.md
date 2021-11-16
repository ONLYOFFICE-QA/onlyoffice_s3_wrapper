# Change log

## master (unreleased)

### New Features

* Add `ruby-3.0` to CI
* Check `simplecov` branch coverage in CI

## 0.4.0 (2020-11-28)

### Changes

* Freeze dev dependencies version in `Gemfile.lock`

## 0.3.0 (2020-09-11)

### Changes

* Remove support of reading keys from `ENV`
* Freeze dev dependencies version in `Gemfile.lock`

### Fixes

* Fix incorrect keys read from config files
* Add `markdownlint` config file

## 0.2.0 (2020-09-10)

### New Features

* `download_file_by_name` return file path
* Add support to specify file download
  location to `download_file_by_name`
* `download_object` raise more detailed error
* Add `markdownlint`-check task in CI
* Add `rubocop` check to CI
* Add `yard` task that gem fully documented
* Add all missing documentation
* Add tests for 100% coverage
* Add `dependabot` config
* Add `rake` task to release gem on
  both `rubygems` and `GitHub Packages`

### Fixes

* Fix coverage report on non-CI

### Changes

* Use GitHub Actions instead of TravisCI
* Drop support of rubies older than 2.5
* Move `gem` homepage to new organization
* Cleanup `gemspec` file
* Fully redone README file
* Freeze specific version of dependencies
* Drop `codecov` support

## 0.1.2 (2020-01-24)

* Reformat log while downloading files
* Use `aws-sdk-s3` instead of unified gem
* Files can be uploaded to root of bucket
* Add Rakefile and tasks for releasing gem

## 0.1.1 (2018-02-01)

* Ability to get any field in `get_files_by_prefix`

## 0.1.0 (2017-10-31)

* Initial release of `onlyoffice_s3_wrapper` gem
