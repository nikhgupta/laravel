Feature: Generate a new key for Laravel application
  In order to make the Laravel application more secure
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to generate a key

  @may_require_repository_download
  Scenario: generate a new key for a Laravel application
    Given laravel application exists in "my_app" directory
    When  I run `laravel config key --app=my_app`
    Then  configuration: "key" must be updated to "__something__" for "my_app" application

  @may_require_repository_download
  Scenario: create Laravel application and generate a key for it
    When  I run `laravel new my_app --key`
    Then  laravel application should be ready to use in "my_app" directory
    And   configuration: "key" must be updated to "__something__" for "my_app" application
