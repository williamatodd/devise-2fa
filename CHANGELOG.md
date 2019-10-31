# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.4.1] - 2019-10-31
### Changed
- Adds missing methods to ActiveRecord generator to fix issue #16.
- Adds a missing manifest.js to Dummy application.
- Fixes devise_error_messages! deprecation warning by using the new partial.
- Fixes sqlite3.represent_boolean_as_integer deprecation warning in specs.

## [0.4.0] - 2019-08-22
### Added
- Appraisal suite.
- Mongoid specs.

### Changed
- Refactors #validate_otp_token_with_drift from #15.
- Upgraded rotp dependency to ```~> 5.1```.

## [0.3.0] - REVOKED

## [0.2.1] - 2019-05-28
### Changed
- Relaxed Rails dependency to ```~> 6.1```.
- Upgraded symmetric-encryption dependency to 4.3.0
- Upgraded rotp dependency to ```~> 4.0```.

## [0.2.0] - 2019-04-29
### Changed
- Test suite migrated to RSpec.

## [0.1.1] - 2016-04-28
### Changed
- Relaxed Devise dependency to ```~> 4.0```.

## [0.1.0] - 2016-04-28
### Added
- Initial release.
