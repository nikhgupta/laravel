Feature: Create a new application based on Laravel framework for PHP
  In order to develop awesome web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to setup Laravel framework

  @requires_repository_download @very_slow @online 
  Scenario: create Laravel application with default settings
    Given local cache does not exist for "official" repository
    When  I run `laravel new my_app`
    Then  laravel application should be ready to use in "my_app" directory

  @may_require_repository_download 
  Scenario: create Laravel application in the current directory
    When  I run `laravel new . --force`
    Then  laravel application should be ready to use in "." directory
    When  I run `laravel new .`
    Then  the stdout should contain "ERROR"

  @requires_repository_download @online 
  Scenario: create Laravel application using source from a non-official repo
    Given local cache does not exist for "pastes" repository
    When  I run `laravel new my_app --source=http://github.com/laravel/pastes`
    Then  laravel application should be ready to use in "my_app" directory using "pastes" repository

  @requires_repository_download @online
  Scenario: create Laravel application using non-laravel repository
    When  I run `laravel new my_app --source=http://github.com/github/gitignore`
    Then  local cache for "non_laravel" repository should not exist
    And   the stdout should contain "corrupt"
    And   the stdout should contain "ERROR"
    And   laravel application must not exist in "my_app" directory

  @may_require_repository_download
  Scenario: create Laravel application using repository from local cache
    Given local cache exists for "pastes" repository
    When  I run `laravel new my_app --source=http://github.com/laravel/pastes`
    Then  laravel application should be ready to use in "my_app" directory using "pastes" repository

  @may_require_repository_download 
  Scenario: create Laravel application using source from a directory
    Given laravel source has already been downloaded in "laravel" directory
    When  I run `laravel new my_app --source=laravel`
    Then  laravel application should be ready to use in "my_app" directory

  @may_require_repository_download
  Scenario: create Laravel application but do not update permissions on storage/ directory
    When  I run `laravel new my_app --no-perms`
    Then  the stdout should contain "Hurray!"
    And   laravel application must exist in "my_app" directory
    And   permissions should not be updated on "my_app/storage" directory

  @may_require_repository_download
  Scenario: create Laravel application with maximum customizations
    When I run `laravel new -kgi 'home.php' -s http://github.com/laravel/pastes my_app --force`
    Then laravel application should be ready to use in "my_app" directory using "pastes" repository
    And  the stdout should contain "Creating application forcefully"
    And  configuration: "key" must be updated to "__something__" for "my_app" application
    And  configuration: "index" must be updated to "home.php" for "my_app" application
    And  task: "generator" should be installed as "generate.php" for "my_app" application
