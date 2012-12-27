Feature: Download Laravel Generator by Jeffrey Way
  In order to generate code for my application quickly using :generate tasks
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to download Laravel Generator by Jeffrey Way

  Background: An application based on Laravel framework exists
    Given I want to create a new application
    When  I create this application
    Then  the application should be ready for development

  Scenario: download Laravel generator
    When  I install generator for this application
    Then  a task should be installed as "generate.php"
