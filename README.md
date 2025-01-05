# TodoApp

A Flutter-based task management app with Firebase integration. Manage tasks in categories like "Today," "Tomorrow," and "Next Week" with real-time updates and a sleek UI.

## Features
- Task categorization for better organization.
- Real-time data sync via Firebase Firestore.
- Cross-platform support (iOS and Android).

## Prerequisites
- Flutter SDK (3.0.0+), Dart SDK, Android Studio/VS Code.
- Firebase setup for the app.

## Setup Instructions
1. Clone the repository:  
   ```bash
   git clone https://github.com/your-repo/todoapp.git
   cd todoapp
   flutter pub get
   ```
2. Configure Firebase: Replace `firebase_options.dart` with your Firebase config.
3. **Comment Out `.gitattributes`:**  
   Open `.gitattributes` and comment its content:  
   ```plaintext
   #*.dart linguist-language=Dart
   ```
4. Run the app:  
   ```bash
   flutter run
   ```

## Contribution
Fork the repo, create a branch, and submit a pull request.  

## License
This project is licensed under the [MIT License](LICENSE).
