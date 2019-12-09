Feature: App Bar
  User should be able to switch between different Screens using the App Bar.

  Scenario: User Taps on "Search"
    Given I expect the user taps on "Search"
    Then user should land on "search_screen"

  Scenario: User Taps on "News"
    Given I expect the user taps on "News"
    Then user should land on "news_screen"

  Scenario: User Taps on "Calendar"
    Given I expect the user taps on "Calendar"
    Then user should land on "calendar_screen"

  Scenario: User Taps on "Settings"
    Given I expect the user taps on "Settings"
    Then user should land on "settings_screen"