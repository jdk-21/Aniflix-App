Feature: App Bar
  User should be able to switch between different Screens using the Settings Page and switch the theme.

  Scenario: User Taps on "Profil"
    Given I expect the user taps on "Settings"
    Then I expect the user taps on "Profil"
    Then user should land on "profile_screen"

  Scenario: User Taps on "Verlauf"
    Given I expect the user taps on "Settings"
    Then I expect the user taps on "Verlauf"
    Then user should land on "history_screen"

  Scenario: User Taps on "Watchlist"
    Given I expect the user taps on "Settings"
    Then I expect the user taps on "Watchlist"
    Then user should land on "watchlist_screen"

  Scenario: User Taps on "Favoriten"
    Given I expect the user taps on "Settings"
    Then I expect the user taps on "Favoriten"
    Then user should land on "favourites_screen"

  Scenario: User switches "Theme"
    Given I expect the user taps on "Settings"
    Then I expect the user taps on "themes"
    Then I expect the user taps on "Dark Theme"
    Then I expect the user taps on "themes"
    Then I expect the user taps on "Light Theme"
    Then I expect the user taps on "themes"
    Then I expect the user taps on "Blue Dark Theme"