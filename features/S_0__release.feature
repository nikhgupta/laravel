Feature: Basic configurations and testing
  In order to release the gem
  As an author of this gem
  I want to test basic configuration for this gem

  @release
  Scenario: Release the gem
    Given I want to make sure everything runs before releasing the gem
    Then  the working directory should not be dirty
    And   the version should be updated
    And   the readme should be updated with new information
    And   the directory with laravel data should not exist
    And   snapshotted git commits should not exist
