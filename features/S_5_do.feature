Feature: Run artisan commands via gem
  In order to use the artisan command-line tool
  As a PHP developer acquinted with ruby
  I want to use the Laravel gem to call artisan commands

  Background: An application based on Laravel framework exists
    Given I want to create a new application
    When  I create this application
    Then  the application should be ready for development

  Scenario: run application tests using artisan
    When  I run `laravel do test` inside this application
    Then  I should see "PHPUnit"
