Feature: Download Laravel Generator by Jeffrey Way
  In order to generate code for my application quickly using :generate tasks
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to download Laravel Generator by Jeffrey Way

  @may_require_repository_download
  Scenario: download Laravel generator
    Given laravel application exists in "my_app" directory
    When  I run `laravel get_generator --app=my_app`
    Then  generator tasks should be setup for "my_app" application

  @may_require_repository_download
  Scenario: download Laravel generator while creating an application
    When  I run `laravel new my_app --generator`
    Then  laravel application should be ready to use in "my_app" directory
    And   generator tasks should be setup for "my_app" application
