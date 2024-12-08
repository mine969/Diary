-Adding Splash Screen + Logo
-Main Screen
-Login Screen

lib/
├── main.dart                        // Entry point of the application
├── splash_screen.dart               // Splash Screen widget
├── diary/                           // Diary-related features
│   ├── diary_screen.dart            // Diary screen displaying the list of entries
│   ├── add_diary_entry.dart         // Screen for adding new diary entries
│   ├── diary_model.dart             // Optional: Data model for Diary Entry
├── widgets/                         // Reusable widgets
│   ├── custom_button.dart           // A custom button widget
│   ├── text_field_widget.dart       // A custom TextField widget
├── services/                        // Firebase or other service-related code
│   ├── firebase_service.dart        // Functions for interacting with Firestore
├── utils/                           // Utility classes, helper functions
│   ├── constants.dart               // Constants like strings, colors
│   ├── validation.dart              // Validation logic for form inputs
├── theme/                           // Theme and styling related code
│   ├── app_theme.dart               // Global theme configuration
└── models/                          // Data models
    ├── diary_entry.dart             // Data structure for Diary Entry (optional)