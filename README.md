# Speak Up - English Learning App - Flutter

Speak Up is an English learning app developed to help users improve their English language skills through various interactive features and resources. This repository contains the source code for the app.

## Table of Contents

- [Development Stack](#development-stack)
- [Getting Started](#getting-started)
- [Features](#features)
- [Screenshots](#screenshots)
- [Author](#author)

## Development Stack
- **Architecture**: Layered Architecture:
```mermaid
graph TD;
    domain-->data;
    presentation-->domain;
    presentation-->data;
```
    

- **Dependency Injection**: GetIt.

- **State Management**: Riverpod + MVVM (Model - View - ViewModel).

- **Network Integration**: Dio + Retrofit, Json Serialization.

- **Cloud Services**:
  + Firebase: Authentication, Firestore Database, ...
  + Microsoft Azure: Pronunciation Assessment

- **API Integration**: Youtube API, OpenAI API.

- **Local Data Storage**: Shared Preferences, SQLite.

## Getting Started

To run this app locally, follow these steps:

1. Clone this repository to your local machine using
   ```
   git clone https://github.com/letanssang/speak_up_flutter.git
   ```

2. Open the project in Android Studio or your preferred IDE.

3. Ensure you have the necessary Flutter environment set up.
4. Create `keys.env` file  and paste it into `assets/keys/` directory with this format:
```
AZURE_SPEECH_KEY=....
OPEN_AI_KEY=...
```

  
6. Run
   ```
   flutter pub get
   dart run build_runner build
   ```

7. Run the app on an emulator or physical device.
## Features
- **Authentication**: Sign up and log in using Google, email. Edit user profiles and personalize your learning journey.

- **Multilingual**: Choose between English and Vietnamese as your interface language.
  
 - **UI Modes**: Customize your app experience with both Dark Mode and Light Mode..

- **Conversation Practice**: Listen to and repeat 75 English dialogues across various topics to enhance your speaking skills.

- **English Lessons**: Explore a variety of English lessons, including common phrases, sentence patterns, idioms, and more.
  
- **Learning Mode**: Engage in various learning modes, including quizzes, flashcards, and more..

- **Pronunciation Evaluation**: Get feedback on your pronunciation and practice all 44 IPA (International Phonetic Alphabet) sounds.

- **Reels and Learning**: Enjoy learning English while watching entertaining reels and videos.

- **Chatbot**: A chatbot based on ChatGPT.


## Screenshots
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/caf3d3a9-2d8d-416e-b5b3-174313b457b3" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/3f9d74ed-a9bb-46d7-b1d6-d57084ea642d" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/1bf656ac-ae3d-4578-a9f2-e7a8cf9ad467" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/eb4c455a-330b-42a6-bd77-de48a39b7e05" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/02ac12c7-0949-45a8-85c7-c36c19ce5010" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/233685eb-4e52-4d47-88fa-e51355994228" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/1c9af9fb-618b-4235-bf11-cbab2472c643" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/1a25bf98-0297-4312-8ad6-39c40c95bb71" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/b50a6383-0a66-4c01-b2f1-2daec9809710" width=375/>
<img src="https://github.com/letanssang/speak_up_flutter/assets/67082439/2eb4c191-49c8-41be-ac5c-40766b4a099f" width=375/>

## Author

**Tan Sang Le**

- LinkedIn: [Tấn Sang Lê](https://www.linkedin.com/in/letansang/)
- GitHub: [letanssang](https://github.com/letanssang)
- Email: letan.ssang@gmail.com
  






