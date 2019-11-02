Feature: Get subscribed animes
  As a registered user
  I want to see new episodes of my subscribed animes
  so that I get a filled subscription box

  Scenario: Show subscription box
    Given: I started the app
    And: I am a registered user
    When: I opened the subscription box
    And: I requested my user
    And: I requested my subscribed animes
    And: I requested the newest episodes of my subscribed animes
    Then: I get a list with the newest episodes of my subscribed animes sorted by their release dates
    And: They are visualized in the subscription box sorted by their release date