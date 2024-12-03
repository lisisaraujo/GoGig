[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/lf0EMZwr)

# Care4U

**Your go-to app for finding and offering services like cooking, cleaning, or personal assistance.**

Care4U is a social support app that allows users to offer or seek services such as cooking, cleaning, or personal assistance. Users can mark their services as paid, in exchange, or both. The app serves as a network to quickly find someone to help with tasks while also providing opportunities for individuals to earn extra money by sharing their hobbies, like cooking.

## Design
<p>
  <img src="./img/screen1.png" width="200">
  <img src="./img/screen2.png" width="200">
  <img src="./img/screen3.png" width="200">
</p>

## Features
Here are the features that Care4U offers:

- [x] User Authentication (Login and Register)
- [x] Profile Management (Edit Profile, View My Posts)
- [x] Tab Navigation Menu
- [x] Homepage with Search and Offers
- [x] Add Post Functionality
- [x] Bookmarking Posts
- [x] User Inbox for Messaging (Bonus Feature)
- [x] User Reviews and Ratings

## Technical Structure

#### Project Structure
The project follows the MVVM and Repository architecture pattern. 

#### Data Storage
Data is stored using Firebase. User authentication details, posts, and user profiles are managed through Firebase Firestore. This choice allows for real-time data synchronization and easy scalability.

#### API Calls
The app utilizes the Google Places API to enhance the search functionality for services offered by users.

#### 3rd-Party Frameworks
Care4U integrates several third-party frameworks:
- ...
- ...

## Outlook
In the future, we plan to enhance Care4U with additional features:

- [ ] Planned Feature: Advanced Filtering Options for Posts
- [ ] Planned Feature: Live Messaging Chat
- [ ] Push Notifications for Updates 
