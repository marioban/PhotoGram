# PhotoGram
### Aadbdt - 5 patterns is working branch

PhotoGram is a feature-rich social media platform inspired by Instagram, designed to enable users to share their life moments through pictures. Users can interact with the community by following others, liking, commenting, and saving pictures. The application supports a versatile user authentication system, including anonymous browsing, local registration, and sign-in via Google.

## Features

- **User Authentication**: Supports anonymous browsing, local account creation, and Google sign-in.
- **Feed View**: Users can browse a dynamic feed displaying photos from people they follow or explore new content in anonymous mode.
- **User Interactions**:
  - **Follow/Unfollow**: Discover and follow other users.
  - **Likes and Comments**: Engage with the community by liking pictures and commenting on them.
  - **Save and Download**: Save pictures to view later or download them directly to your device.
- **Search Functionality**: Users can search for other users by their usernames.
- **Content Posting**: Upload pictures with descriptions and tag their locations.
- **Notifications**: Receive updates about interactions and engagements from other users.
- **User Profiles**: View your own and others' profiles, manage your posts, edit personal details, see your followers and following lists.

## Technical Overview

PhotoGram incorporates six design patterns to streamline its architecture and enhance its functionality:

- **Decorator (Notifications)**: Enhances objects with new responsibilities dynamically, used to manage notifications in a flexible way.
- **Command (Comments)**: Encapsulates all the information needed to perform an action or trigger an event, used in the commenting feature.
- **Observer (Search)**: Allows subscribers to receive updates about other users, enhancing the search functionality.
- **Composite (Profile)**: Used to construct a tree structure for individual and collective profiles.
- **Facade (Feed)**: Provides a simplified interface to complex subsystems involved in generating the feed.
- **Repository (Realm Saved Posts)**: Provides a straightforward way to manage persistent data, such as posts saved by users.

## Getting Started

To get started with PhotoGram:

1. Clone the repository to your local machine.
2. Install the required dependencies.
3. Ensure you have a valid Google API key configured if you intend to use Google sign-in features.
4. Build and run the application in your preferred development environment.
