Feature: Create a new application with maximum customizations
  In order to develop awesome web application
  As a PHP developer acquinted with ruby
  I want to use Laravel gem to setup a new application with maximum customizations

  Scenario: create Laravel application with maximum customizations
    Given I want to create an application forcefully
    And   I want to use "http://github.com/laravel/pastes" as source
    And   I want to generate a new key
    And   I want to use "home.php" as application index
    When  I create an application with above requirements
    Then  application should be ready for development
    And   a new application key should be generated
    And   the application index should be updated to "home.php"
