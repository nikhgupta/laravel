Feature: Laravel 'new'
  In order to create a new application based on Laravel framework
  As a PHP developer acquinted with ruby
  I want to use Laravel gem

  @requires_repository_download @very_slow
  Scenario: create Laravel application with default settings
    Given local cache does not exist for "official" repository
    When  I run `laravel new my_app`
    Then  local cache for "official" repository should exist
    And   the stdout should contain "Hurray!"
    And   laravel application must be created inside "my_app" directory

  @requires_repository_download
  Scenario: create Laravel application using source from a non-official repo
    Given local cache does not exist for "pastes" repository
    When  I run `laravel new my_app --remote=http://github.com/laravel/pastes`
    Then  local cache for "pastes" repository should exist
    And   the stdout should contain "Hurray!"
    And   laravel application must be created inside "my_app" directory

  @may_require_repository_download
  Scenario: create Laravel application using repository from local cache
    Given local cache exists for "official" repository
    When  I run `laravel new my_app --remote=http://github.com/laravel/pastes`
    Then  the stdout should contain "Hurray!"
    And   laravel application must be created inside "my_app" directory

  @may_require_repository_download
  Scenario: create Laravel application using source from a directory
    Given laravel source has already been downloaded in "laravel" directory
    When  I run `laravel new my_app --local=laravel`
    Then  the stdout should contain "Hurray!"
    And   laravel application must be created inside "my_app" directory

  @requires_repository_download
  Scenario: create Laravel application using non-laravel repository
    When  I run `laravel new my_app --remote=http://github.com/github/gitignore`
    Then  local cache for "non_laravel" repository should not be created
    And   the stdout should contain "source is corrupt"
    And   laravel application must not be created inside "my_app" directory
