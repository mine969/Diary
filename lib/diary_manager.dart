import 'diary_entry.dart';

class DiaryManager {
  // In-memory list of diary entries
  final List<DiaryEntry> _entries = [
    DiaryEntry(
      title: 'First Entry',
      content: 'This is the first diary entry.',
      date: DateTime.now().subtract(Duration(days: 2)),
    ),
    DiaryEntry(
      title: 'Second Entry',
      content: 'Today I worked on Flutter.',
      date: DateTime.now().subtract(Duration(days: 1)),
    ),
    DiaryEntry(
      title: 'Third Entry',
      content: 'I added CRUD functionality.',
      date: DateTime.now(),
    ),
  ];

  // Get all entries
  Future<List<DiaryEntry>> getEntries() async {
    return Future.delayed(Duration(seconds: 1), () => _entries);
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
