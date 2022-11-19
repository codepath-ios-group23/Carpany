# Carpany

## Table of Contents
1. [Overview](#Overview)
1. [Product Spec](#Product-Spec)
1. [Wireframes](#Wireframes)
2. [Schema](#Schema)

## Overview
### Description
**Carpany** is an iOS Application for all car sellers, car owners and car fans. In Carpany, people can stay up-to-date with the latest car news, filter the posts they are interested in and read the full text, and search for information about specific cars and car-related products, including: release dates, latest prices and discounts, word of mouth and reviews, etc. In addition, car fans with the same interests can create their own circles of different themes and chat, share posts and post messages in them. Users can also add friends to each other, share and chat. Various posts within the software can also be shared on different social media platforms. Car manufacturers and retailers of related products can also register in the application and post information and posts about their products. In addition, the application also integrates with the map function, which allows people to find parking lots, related stores, gas stations, as well as mark the related car retailers and product discount stores according to the cars owned by different users, etc.

### App Evaluation
- **Category:** Social Networking / Information Retrieving
- **Mobile:** This app would be primarily developed for iOS mobile.
- **Story:** Provide a platform for car sellers, owners and sellers. Help people of same car hobbies meet each other here, gain more happiness. Provide a way for car related products sellers to post their information. Help people like cars gain more convenience and happiness here in the app.
- **Market:** Any individual could choose to use this app, only if you like cars, want know more about cars, or want to sell products about cars.
- **Habit:** Anytime you feel free you can open this app to chat with your friends or see anything new updated here. Anytime you want find some services about cars you could also use this app to help you. If you are busy, it is still OK to keep it closed in your pocket.
- **Scope:** First we plan to create basic functions such as import information of different cars in our database, creating posts, sharing information and provide information on maps. As a result, we might intergrate apis of some applications such as `cars.com`, `Google Map` and `Twitter`. Later, we might update more interesting functions like car modification simulation, car pricing evaluation and so on. The App has large potential for better use when working with the help of social networking apps and recommondation algorithms in the future.

## Product Spec

### 1. User Stories (Required and Optional)

**Required Must-have Stories**
* User can login / logout
* Create new accounts before login
* Skim / communicate with posts
* Search / sift posts with specific conditions
* See details and related links of chosen car
* Update self-information on Profile
* Skim basic locations in neighborhood on map
* Save cars in my garage
* Basic settings (auto-login, remember, private / public showing content)


**Optional Nice-to-have Stories**

* Self designed Profile Theme
* Chat with friends
* Create / join circles of different themes
* Search by color, ratings, reviews
* Make comments on posts
* Create collections and collect posts in them
* Find people of similar hobbies
* Find owners of similar cars
* Provide locations on map accoriding to my car
* Navigate with map
* Car modification simulate
* Price evaluate
* Emoji self-status

### 2. Screen Archetypes

* Login Screen
    * Input `username` / `email` / `mobile phone` and `password` to login
    * Create a new account in the Login Screen
    * Login Screen can remember the last three `username`, so that user could choose any of them to fill the textfield and login
    * The last `username` could be filled automatically
    * Choose whether to remember the `password`
    * Choose whether to login automatically
* Home Screen
    * Home Tab(1st tab)
        * Logout here
        * Skim most recent posts here
        * Search posts by keywords
        * Post posts here
        * Choose showing posts by timeline
        * Pull to refresh posts
        * Load past posts infinitely
        * Thumbs up / thumbs down on each post
    * Map Tab (2nd tab)
        * Get self-location
        * See parking locations on map
        * Find car rentals, related shops and repair shop in the neighbourhood
    * Search Tab (3rd Tab)
        * Search information cars by name / brand
        * Search cars by giving price range
        * Search for cars are discounted
    * Profile Tab (4th Tab)
        * Upload their avatar
        * Update their basic information (name, email, phone, etc.,)
        * Write a self-description and show them on the self-profile
        * Update their status
        * Choose cars from database into their garage
        * See their friend lists here
        * See previous self-posts here
* Edit Screen
    * Typing
    * Real-time letter counting
    * Attach images / Take photos
    * Select related car items from database
    * Add labels
* Detailed reading screen
    * Thumbs up / thumbs down on each post
    * See full text
    * See basic information of the post
* Car Details Screen
    * Basic information table
    * Car images gallery
    * Ratings
    * Shop / Discount link
* Garage Screen
    * See my car items
    * Reorder by different conditions

### 3. Navigation

**Tab Navigation** (Tab to Screen)

* Home Tab
* Map Tab
* Search Tab
* Profile Tab

Optional:

* Circles
* Chats

**Flow Navigation** (Screen to Screen)

* Forced login -> Account creation if chosen / no login is available
* Forced / automatic login -> Home Screen with most recent posts
* Home Screen logout -> Login Screen and disactive automatic login
* Home Screen edit button chosen -> Edit Screen with cursor focus in text field
* Home Screen post selection -> Detailed Post Screen
* Search Screen car item selection -> Car Details Screen
* Profile Screen -> Garage Screen
* Garage Screen car item selection -> Car Details Screen
* Tabbar Home -> Home Screen
* Tabbar Search -> Search Screen
* Tabbar Profile -> Profile Screen
## Wireframes
<img src="https://i.imgur.com/UtxZH5I.jpg" width=600>

## Digtal Wireframes & Mockups
<img src="https://i.imgur.com/sgzduCj.png" width=600>

## Interactive Prototype
<img src="https://i.imgur.com/A272SSO.gif" width=600>

## Schema 

### Models

#### Post

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user post (default field) |
   | author        | Pointer to User| image author |
   | images        | List of Files     | images that user posts |
   | cars          | List of Pointers to Car     | cars mentioned in the post |
   | caption       | String   | image caption by author |
   | commentsCount | Number   | number of comments that has been posted to an image |
   | comments      | List of Pointers to Comment   | number of comments that has been posted to an image |
   | likesCount    | Number   | number of likes for the post |
   | createdAt     | DateTime | date when post is created (default field) |
   | updatedAt     | DateTime | date when post is last updated (default field) |
#### User

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | objectId      | String   | unique id for the user (default field) |
   | userName      | String   | name displayed on user's profile |
   | gender        | Number   | user's gender |
   | status        | Number   | user's current status/feeling |
   | description   | String   | description/self-introduction of the user |
   | owns          | List of Pointers to Cars   | cars the user owns |
   |createdAt|DateTime|Date when account is created|
#### Car

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   | carId         |String        |unique id for car(default field)|
   | carName|String|car name              |
   |brand|Pointer|id for car's brand|
   |carDescription|JSON|description of cars|
   |carImages|List of Files|Images for cars|
   |likeNum|Number|number of users that favor this car|
#### Brand

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   |brandId| String| unique id for brand(default field)|
   |brandName|String|name for car's brand|
   |brandDescription|String| description for this brand|
   |foundationYear|DateTime|year of foundation for this brand|
   
#### Comment

   | Property      | Type     | Description |
   | ------------- | -------- | ------------|
   |commentId|String|unique id for comments(default field)|
   |content|String|content for comments|
   |author|Pointer to user|user id|
   |createdAt|DateTime|date when comments are created|
   |updatedAt|DateTime|date when comments are updated|

### Networking
#### List of network requests by screen
   - Home Screen
      - Home Tab
          - (Read/GET) Query all posts where user is author
             ```swift
             let query = PFQuery(className:"Post")
             query.whereKey("author", equalTo: currentUser)
             query.order(byDescending: "createdAt")
             query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) in
                if let error = error { 
                   print(error.localizedDescription)
                } else if let posts = posts {
                   print("Successfully retrieved \(posts.count) posts.")
               // TODO: Do something with posts...
                }
             }
             ```
          - (Create/POST) Create a new like on a post
          - (Delete) Delete existing like
          - (Create/POST) Create a new comment on a post
          - (Delete) Delete existing comment
          - (Search/POST) Search existing posts with parsed keywords
          - (Filter/POST) Show existing posts with conditions
      - Map Tab
          - (Search/POST) Search existing locations with parsed keywords
          - (Filter/POST) Show existing locations with conditions
      - Search Tab
          - (Search/POST) Search existing cars with parsed keywords
          - (Add/GET) Add car item object into my garage
      - Profile Tab
          - (Read/GET) Query logged in user object
          - (Update/PUT) Update user profile Information 
          - (Update/PUT) Update user status
   - Edit Screen
      - (Create/POST) Create a new post object
      - (Add/POST) Add car item objects
   - Detailed reading screen
      - (Create/POST) Create a new like on a post
      - (Delete) Delete existing like
      - (Create/POST) Create a new comment on a post
      - (Delete) Delete existing comment
   - Car Details Screen
      - (Add/GET) Add car item object into my garage
   - Garage Screen
      - (Filter/POST) Show existing favorite cars with conditions3
      - (Delete) Delete existing owned car item object

## Milestone1
- [x] User can login(required)
- [x] Create new accounts before login(required)
- [x] User Profile First Design(required)
- [x] Search Tab Table View created(required)

## Video Walkthrough1
<img src="https://i.imgur.com/Eg4h7Ij.gif" width=400>

## Milestone2
- [x] User can auto login/logout(required)
- [x] User Profile could change according to gender(required)
- [x] Create user garage table views(required)
- [x] Build database and upload it to back4app(required)
- [x] Upload image files into server and connect through api(required)
- [x] Build map for self-loaction and location search(required)


## Video Walkthrough2
<img src="https://i.imgur.com/YvA8IY3.gif" width=400>

## Milestone3
- [x] Skim / communicate with posts(optional)
- [x] User can search and view car details(required)
- [x] User can add cars or remove cars from garage in car details page(optional)
- [x] User can filter to search gas station, car rental, parking, EV charger in map function(optional)
- [x] User can post, comment, add picture in the home screen(required)
- [x] User can thumb up or thumb down on posts(optional)
- [x] User can read the full text when clicks on each post(required)
- [x] User can see the detail information of the user who posted the post(required)
- [x] User edit the profile image, status, nickname, and bio(required)

## Video Walkthrough3
<img src="https://i.imgur.com/A8GaP8b.gif" width=400>
 
## Milestone4
- [x] Thumbs up/down in detail reading screen(required)
- [x] People could see all comments in deatail reading screen with a better UI(required)
- [x] Now people could submit posts with multiple images(required)
- [x] Now people could choose the way of uploading images(required)
- [x] Now home page has a limitaion of images amount, comments length and comments amount(required)
- [x] People could all images in the detail reading page(required)
- [x] User could search for posts by using keywords of post's content and poster's name(required)

## Video Walkthrough4
[Carpany Demo Video](https://www.youtube.com/watch?v=yDyZk5129VM)


