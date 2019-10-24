# Use-Case Specification: See subscribed anime

# 1. Get home page anime

## 1.1 Brief Description
You open the subscription box and send a request to the system which will search your subscribed animes based on your user and returns a list of the newest episodes of your subscribed animes.

## 1.2 Mockup
![Mockup](https://raw.githubusercontent.com/d0mmi/Aniflix-App/UC_Get_Anime_Homepage/docs/Mockups/UC_Get_Animes_in_SubBox.png)

## 1.3 Screenshot


# 2. Flow of Events

## 2.1 Basic Flow

### Activity Diagram
![Activity Diagram](https://raw.githubusercontent.com/d0mmi/Aniflix-App/UC_Get_Anime_Homepage/docs/activity_diagramm_see_subscribed_anime.png)

### .feature File

Feature: Get subscribed animes
	
	Scenario: Show subscription box
	Given: I requested a list with the new episodes of my subscribed animes by the "request episodes of the animes" activity
	When: I opened the subscription box
	And: I requested my user
	And: I requested my subscrbed animes
	Then: I get a list with the newest episodes of my subscribed animes sorted by their release dates
	

## 2.2 Alternative Flows
n/a

# 3. Special Requirements
n/a

# 4. Preconditions
The main preconditions for this use case are:

 - The user opened the subscription box
 - The user have an internet connection
 - The user has a registered account
 - The user subscribed to an anime

# 5. Postconditions

The main postconditions for this use case are:

 - Their will be different lists with the newest episodes of my subscribed animes. Each list contains the episodes released on the different days

# 6. Function Points
(n/a)