Feature: Navigation Bar
  User should be able to switch between different Screens using the Navigation Bar.

  Scenario: User Taps on "Home"
    Given I expect the user taps on "Home"
    Then user should land on "home_screen"

  Scenario: User Taps on "Abos"
    Given I expect the user taps on "Abos"
    Then user should land on "sub_screen"

  Scenario: User Taps on "Alle"
    Given I expect the user taps on "Alle"
    Then user should land on "allAnime_screen"