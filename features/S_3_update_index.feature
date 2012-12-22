Feature: Update Application Index for a Laravel based application
  In order to have pretty links in my web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to update Application Index for this application

  @may_require_repository_download
  Scenario: update Application Index in a Laravel application
    Given laravel application exists in "my_app" directory
    When  I run `laravel update_index 'home.php' --app=my_app`
    Then  application index must be set to "home.php" for "my_app" application

  @may_require_repository_download
  Scenario: create Laravel application without an Application Index
    When  I run `laravel new my_app --index=''`
    Then  laravel application should be ready to use in "my_app" directory
    And   application index must be set to "" for "my_app" application
