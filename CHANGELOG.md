# Change log

## master (unreleased)

### New Features

* Add `ruby-3.4` to CI

### Changes

* Remove `ruby-3.0` from CI, since it's EOLed

### Fixes

* Run `rubocop` in CI through `bundle exec`

## 2.1.0 (2024-12-20)

### Changes

* Fix `rubocop-rspec-2.27.0` cop `RSpec/DescribedClass` warnings.
* Fix `rubocop-1.65.0` cop `Gemspec/AddRuntimeDependency`
* Add `base64` dependency, to be compatible with `ruby-3.4`

## 2.0.0 (2024-01-26)

### New Features

* Add `ruby-3.2` in CI
* Add `ruby-3.3` in CI
* Add `dependabot` check for `GitHub Actions`

### Changes

* Remove `@s3` instance variable
* Drop support of `ruby-2.7` since it's EOLed

### Fixes

* Fix `gem` warning about license name
* Fix `gem` warning about `metadata` field

## 1.0.0 (2022-08-06)

### New Features

* Add `ruby-3.1` in CI
* Add `yamllint` check in CI

### Changes

* Actualize `nodejs` version in CI
* Check `dependabot` at 8:00 Moscow time daily
* Changes from `rubocop-rspec` update to 2.9.0
* Remove `ruby-2.5` and `ruby-2.6` support since it's EOLed

## 0.6.0 (2021-12-22)

### New Features

* New method `AmazonS3Wrapper#files_from_folder`

## 0.5.0 (2021-12-10)

### New Features

* Add `ruby-3.0` to CI
* Check `simplecov` branch coverage in CI
* Add `content_type` param for uploading files

### Changes

* Require `mfa` for releasing gem

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
