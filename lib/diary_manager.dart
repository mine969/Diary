import 'dart:async';
import 'diary_entry.dart';

class DiaryManager {
  // In-memory list of diary entries. In a real-world app, this could be a database or a file system.
  List<DiaryEntry> _entries = [];

  // Method to get all diary entries
  Future<List<DiaryEntry>> getEntries() async {
    // Simulate a delay (like fetching data from a database or API)
    await Future.delayed(const Duration(seconds: 1));
    return _entries; // Return the list of entries
  }

  // Method to add a new diary entry
  void addEntry(DiaryEntry entry) {
    _entries.add(entry); // Add the entry to the list
  }

  // Method to update an existing diary entry
  void updateEntry(int index, DiaryEntry updatedEntry) {
    // Ensure the index is valid
    if (index >= 0 && index < _entries.length) {
      _entries[index] = updatedEntry; // Replace the old entry with the updated one
    }
  }

  // Method to delete a diary entry by index
  void deleteEntry(int index) {
    // Ensure the index is valid
    if (index >= 0 && index < _entries.length) {
      _entries.removeAt(index); // Remove the entry from the list
    }
  }

  // Optionally: You could implement saving the data to a file or database here
  // For example, using SharedPreferences, SQLite, or a file system (for persistence).
  // Here's a simple example of how you could save to disk (or a database):
  // Future<void> saveEntriesToDisk() async {
  //   // Your disk-saving logic goes here (e.g., using shared_preferences or SQLite).
  // }
}

