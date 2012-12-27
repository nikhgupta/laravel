Feature: Configure an existing Laravel application
  In order to customize the application to my needs
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to configure this application

  Background: An application based on Laravel framework exists
    Given I want to create a new application
    When  I create this application
    Then  the application should be ready for development

  Scenario: generate a new key for a Laravel application
    When  I generate a new key for this application
    Then  a new application key should be generated

  Scenario: update Application Index in a Laravel application
    When  I udpate application index to "home.php"
    Then  the application index should be updated to "home.php"
