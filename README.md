# PlanZ

**PlanZ** is a personalized travel guide app with short-form video inspiration, seamless planning, and AI-driven insights for an immersive journey. It aims to simplify travel planning by aggregating all the tools you need to discover hidden travel gems, create itineraries, and make reservations within a single platform. 

## Table of Contents
- [Introduction](#introduction)
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Technologies Used](#technologies-used)
- [Business Model](#business-model)
- [Future Growth Plan](#future-growth-plan)
- [License](#license)

## Introduction

Planning trips can often be overwhelming due to fragmented platforms and local app requirements. PlanZ addresses these issues by consolidating everything you need in one app. Whether it's discovering destinations, planning trips, or booking accommodations and activities, PlanZ allows travelers—especially Gen Z and Millennials—to have a seamless experience tailored to their preferences.

PlanZ initially focuses on international travelers visiting South Korea and domestic travelers exploring lesser-known spots.

## Features

1. **Discover Hidden Gems through Short-Form Videos**  
   Users can browse travel spots via short-form videos uploaded by travel creators, providing realistic views and recommendations. Videos can feature popular tourist spots, celebrity-visited places, and lesser-known local attractions.

2. **Themed Travel Routes and Itineraries**  
   Suggested tours based on user interests, such as K-Pop, K-Food, and historical sites. Itineraries are based on celebrity visits, local TV shows, or user-specific interests.

3. **Effortless Itinerary Planning**  
   Users can create, modify, or load saved itineraries and share them with friends for group travel planning. The app also integrates video-based inspiration with map views for an optimal planning experience.

4. **Foreigner-Friendly Booking Services**  
   Integrated reservation system for restaurants, tourist attractions, and accommodations, supporting multiple languages (Korean, English, Chinese, and Japanese). This includes local services such as Naver Reservations and CatchTable.

5. **AI Travel Companion - Zee**  
   The AI chatbot Zee provides cultural insights and recommendations like a local friend, helping users navigate cultural nuances and get the most out of their travel.

## Installation

### Prerequisites
- Dart/Flutter SDK installed
- Firebase project set up (Firestore, Authentication, Storage)
- Android Studio or any compatible IDE for Flutter projects
- Your own ChatGPT API key

### Steps
1. Clone the repository:
   ```bash
   git clone https://github.com/jhhwang21c/planZ.git
   ```

2. Navigate to the project directory:
   ```bash
   cd planZ
   ```

3. Install the dependencies:
   ```bash
   flutter pub get
   ```

4. Set up Firebase:
   - Create a Firebase project and enable Firestore, Authentication, and Storage.
   - Add `google-services.json` (for Android) and `firebase-config.js` (for Web) in the respective folders.
   
5. Run the app:
   ```bash
   flutter run
   ```

## Usage

Upon launching PlanZ, users can:
- Browse short-form video content for travel inspiration.
- Create and share detailed itineraries.
- Book accommodations, activities, and restaurants seamlessly.
- Interact with the AI assistant, Zee, for personalized travel advice.

## Technologies Used
- **Frontend**: Flutter (Dart)
- **Backend**: Firebase (Firestore, Authentication, Storage)
- **AI Integration**: Powered by Langchain and GPT-4 for chatbot interactions.
- **State Management**: Flutter's built-in state management using `setState`.

## Business Model
1. **Advertisements**: Travel-related brand and local business advertising.
2. **Commission**: On bookings made through the platform.
3. **User Data Insights**: Offering anonymized travel data analytics to businesses.

## Future Growth Plan
- **Initial Phase**: Focus on South Korean tourism, gather high-quality content from professional creators.
- **Introduction Phase**: Expand content to nationwide attractions, collaborate with local governments.
- **Development Phase**: Integrate with local transportation and booking systems.
- **Expansion Phase**: Scale the model to other countries with a similar travel experience focus.

## License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
