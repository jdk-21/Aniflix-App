Feature: Get different lists of animes on homepage
  As a visitor or a registered user
  I want to see new anime episodes on aniflix, airing animes, new animes to discover and my last watched animes
  so that I get a filled homepage

  Scenario: Show "discover animes"
    Given: I started the app
    When: I open the homepage
    And: I send a request to the aniflix database over an provided Web-API
    And: I request a random list of animes to discover
    Then: I get a list with the requested animes
    And: The list will be visualized on the homepage

  Scenario: Show airing animes
    Given: I started the app
    When: I open the homepage
    And: I send a request to the aniflix database over an provided Web-API
    And: I request a list of animes that are airing at the moment
    Then: I get a list of animes that are airing at the moment
    And: The list will be visualized on the homepage

  Scenario: Show new animes
    Given: I started the app
    When: I open the homepage
    And: I send a request to the aniflix database over an provided Web-API
    And: I request a list of anime episodes that are new on aniflix
    Then: I get a list of anime episodes that are new on aniflix
    And: The list will be visualized on the homepage

  #Scenario: Show continue episodes
  #  Given: I started the app
  #  And: I am a registered user
  #  When: I open the homepage
  #  And: I send a request to the aniflix database over an provided Web-API
  #  And: I request a list of anime episodes with the next episodes of my last watched animes
  #  Then: I get a list of anime episodes with the next episodes of my last watched animes
  #  And: The list will be visualized on the homepage