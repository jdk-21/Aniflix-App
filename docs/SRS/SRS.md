# AniflixApp - Software Requirements Specification

## Table of Contents

- [1. Introduction](#1-introduction)
  * [1.1 Purpose](#11-purpose)
  * [1.2 Scope](#12-scope)
  * [1.3 Definitions, Acronyms, and Abbreviations](#13-definitions--acronyms--and-abbreviations)
  * [1.4 References](#14-references)
  * [1.5 Overview](#15-overview)
- [2. Overall Description](#2-overall-description)
  * [2.1 Vision](#21-vision)
  * [2.2 Use Case Diagram](#22-use-case-diagram)
- [3. Specific Requirements](#3-specific-requirements)
  * [3.1 Functionality](#31-functionality)
  * [3.2 Usability](#32-usability)
  * [3.3 Reliability](#33-reliability)
  * [3.4 Performance](#34-performance)
  * [3.5 Supportability](#35-supportability)
  * [3.6 Design Constraints](#36-design-constraints)
  * [3.7 On-line User Documentation and Help System Requirements](#37-on-line-user-documentation-and-help-system-requirements)
  * [3.8 Purchased Components](#38-purchased-components)
  * [3.9 Interfaces](#39-interfaces)
  * [3.10 Licensing Requirements](#310-licensing-requirements)
  * [3.11 Legal, Copyright and other Notices](#311-legal-copyright-and-other-notices)
  * [3.12 Applicable Standards](#312-applicable-standards)
- [4. Supporting Information](#4-supporting-information)
  * [4.1 Appendices](#41-Appendices)

## 1. Introduction
### 1.1 Purpose
The purpose of this document is to give a general overview over the AniflixApp project. It explains our vision and provide information about the features the app will contain.

### 1.2 Scope
The AniflixApp is an app for everyone who want to watch anime. It is based on the website https://www2.aniflix.tv/ . The app will provide all features the website provides like:
-	A main page where you can discover new animes
-	A list of all animes the website provides
-	A subscription box where you find all the animes you subscribed to
-	A watchlist which shows the animes you like to watch in future
-	A favorites page which show your most favorite animes
-	A watch history of your watched animes
-	An anime calendar which show the animes that will release new episodes the next days
-	A global chat for the website

### 1.3 Definitions, Acronyms and Abbreviations
In this section definitions and explanations of acronyms and abbreviations are listed to help the reader to understand these.

|			Abbreviation									|	Explanation		|
|---------------------------------------------------|---------------|
**Android**| This is a mobile operating system developed by Google which is primarily used on smartphones and tablets.|
**SRS**|Software Requirements Specification|
**API** |Application Programming Interfacem|
**Dart** |Is a programming language developed by google to create apps|
**Flutter** |Is Google's UI toolkit to create apps from a single codebase|


### 1.4 References
|			Title									|	Date		|
|---------------------------------------------------|---------------|
| [AniflixApp Blog](https://aniflixapp.wordpress.com/) | 17.10.2019 |
| [ANiflixApp Git](https://github.com/d0mmi/Aniflix-App) | 17.10.2019 |
| [Overall Use Case Diagramm](https://raw.githubusercontent.com/d0mmi/Aniflix-App/Docu-fixes/docs/UCD_Main.png)| 19.10.2017 |

### 1.5 Overview
The following chapters are about our vision and perspective, the software requirements, the demands we have and
the technical realization of this project.

## 2. Overall Description
### 2.1 Vision
Our idea is to develop an app for the aniflix.tv website. It will be used to watch anime on your smartphone without the need to open the website about a browser.
The app will be developed with google's programming language dart and their toolkit flutter. With an API provided by the website developers we will get the data we need to show the animes in the app.
Ideas for future features will be a MySite for ever user but for now we have to wait for an OK of the main developers of the website. 

### 2.2 Use Case Diagram
The following picture shows the overall use case diagram of our software:
![OUCD]


## 3. Specific Requirements
### 3.1 Functionality
#### 3.1.1 Create Account
You will be able to create your own account on the website to get access to all features aniflix provides.

#### 3.1.2 Get animes on Home Page
The home page shows you your last watched animes, new released episodes and some animes you could like based on your watched animes. This lists of animes will be provided by an API.

	[Use Case: Get animes on homepage](https://github.com/d0mmi/Aniflix-App/blob/Docu-fixes/docs/UC/UC_Get_Anime_HomePage.md)

#### 3.1.3 See all animes provided by aniflix.tv
Shows you all animes the site provides.

#### 3.1.4 See subscribed animes
Here you will see all new episodes of the animes you subscribed to. It is based on your user which give us a list of your subscribed animes.
[See subscribed animes](../docs/UC/UC_Get_Anime_HomePage.md)

#### 3.1.5 Anime Site
The anime site shows all episodes of the selected anime you want to watch. You get a description of the anime and the possibility to subscribe or review the anime.

#### 3.1.6 Episode Site
This site shows you the player to watch the anime and a comment section. You can also report the episode if there are any errors with the episode.

#### 3.1.7 Profile settings
As an unregistered user you can change the theme of the app or use the login option to log in. As an registered user you'll also be able to edit your avatar, see your history, watchlist and favorites.

#### 3.1.8 Chat
You'll be able to chat with all registered user of the site in a global chat.

#### 3.1.9 Review Site
Over the review button on the anime site you can see all reviews wrote for this anime. You will also be able to write your own reviews.


### 3.2 Usability
#### 3.2.1 Smartphone user
The user should know how to use Android as a mobile operating system and how to install and use a mobile application on it. The app will be designed like the aniflix website so users who already use the website will be easily able to use the app. New users which use the youtube app on the smartphone will recognize similarities between the apps to give them the possibility to use the aniflixapp like the youtube app.

### 3.3 Reliability
#### 3.3.1 Server availability
The servers of the website will always be online so the animes should always be available. The only problem could be if the streaming hosters are offline or remove the anime. If this will happen the users are able to report this. The reports will be seen by the site admins on an admin tool. This admin tool will only be available on the website for the admins not on the app.

The communication between the database of the website and the app will work with an API provided by the website hoster.

### 3.4 Performance
Flutter aims to provide 60 frames per second (fps) performance, or 120 fps performance on devices capable of 120Hz updates.
For 60fps, frames need to render approximately every 16ms.

### 3.5 Supportability
#### 3.5.1 Language support
We will use dart and flutter. Dart is client-optimized programming language for fast apps on any plattform made by google. Like dart, flutter is also made by google. It is a toolkit based on dart.

#### 3.5.2 App support
We will clearly separate models, views and controllers like the MVC pattern pretends. Furthermore we aim to keep our code clean which we can't guarantee though. Thereby we make it easy to understand our infrastructure and avoid possible confusion when one needs to edit older parts of the application.

### 3.6 Design Constraints
We will focus on building a modern-looking application, that's the reason why we searched for inspiration on other popular streaming apps.

#### 3.6.1 Development tools
-   Git: version control system
-   JetBrains IntelliJ
-   Eclipse
-   YouTrack: Project planning tool
-   Dart: Programming language by Google
-   Flutter: Toolkit based on Dart by Google
-   Android Studio and Android emulator: To test our application

#### 3.6.2 Page designs
The different pages are designed for an easy use. There will be similarities in usage to the netflix and youtube app to give many users the feeling to already know the usage.

### 3.7 On-line User Documentation and Help System Requirements
Our app will have many similarities with the youtube or netflix app so the users should easily be able to use the app without problems. If they have any questions they could visit our blog to get information about the features.

### 3.8 Purchased Components
(n/a)

### 3.9 Interfaces

#### 3.9.1 User Interfaces
The app will provide different UI's for every feature it will support. The UI's will give the possibility to use the different use cases.
To navigate on the website every page contain a topbar and a botbar. The topbar gives the possibility to search for an anime, get notifications, open the calendar and open the profile settings. The botbar is used to navigate over the three main sites: The homepage where you can discover new animes or keep looking your animes.


#### 3.9.2 Hardware Interfaces
(n/a)

#### 3.9.3 Software Interfaces
To test our app we use the android studio with an android emulator.

#### 3.9.4 Communications Interfaces
There is an Web-API to get the data we need from the website's database.

### 3.10 Licensing Requirement
(n/a)

### 3.11 Legal, Copyright and other Notices
(n/a)

### 3.12 Applicable Standards
(n/a)

## 4. Supporting Information
### 4.1 Appendices
You can find any internal linked sources in the chapter References (go to the top of this document). If you would like to know what the current status of this project is please visit our blog.

[blog]: https://aniflixapp.wordpress.com/ "Blog of project"
[github]: https://github.com/d0mmi/Aniflix-App "Sourcecode hosted at Github"


<!-- Picture-Link definitions: -->
[OUCD]: <https://raw.githubusercontent.com/d0mmi/Aniflix-App/Docu-fixes/docs/UCD_Main.png> "Overall Use Case Diagramm"

