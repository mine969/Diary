import 'diary_entry.dart';  // Ensure this import is at the top

class DiaryManager {
  // Sample data for testing
  List<DiaryEntry> _entries = [
    DiaryEntry(
      title: 'Sample Entry 1',
      content: 'This is a sample entry to test the app functionality.',
      date: DateTime.now(),
      imagePath: null,  // No image path for this entry
    ),
    DiaryEntry(
      title: 'Sample Entry 2',
      content: 'This is another sample entry to demonstrate the diary feature.',
      date: DateTime.now().add(Duration(days: 1)),
      imagePath: null,
    ),
    DiaryEntry(
      title: 'Sample Entry 3',
      content: 'This entry contains some more text and data.',
      date: DateTime.now().add(Duration(days: 2)),
      imagePath: null,
    ),
  ];

  // Fetch all diary entries asynchronously
  Future<List<DiaryEntry>> getEntries() async {
    // Simulate a delay as if fetching from a database or API
    await Future.delayed(Duration(seconds: 1));  // Simulating network delay
    return _entries;
  }

  // Add a new entry
  void addEntry(DiaryEntry entry) {
    _entries.add(entry);
  }

  // Update an existing entry
  void updateEntry(int index, DiaryEntry updatedEntry) {
    _entries[index] = updatedEntry;
  }

  // Delete an entry
  void deleteEntry(int index) {
    _entries.removeAt(index);
  }
}
