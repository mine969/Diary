// diary_entry.dart

class DiaryEntry {
  String title;
  String content;
  String date;

  DiaryEntry({required this.title, required this.content, required this.date});

  // Convert DiaryEntry to Map (useful for saving in plain text)
  Map<String, String> toMap() {
    return {
      'title': title,
      'content': content,
      'date': date,
    };
  }

  // Convert Map back to DiaryEntry object
  factory DiaryEntry.fromMap(Map<String, String> map) {
    return DiaryEntry(
      title: map['title']!,
      content: map['content']!,
      date: map['date']!,
    );
  }

  // Convert to a String (JSON-like format) for plain text storage
  String toString() {
    return '{"title": "$title", "content": "$content", "date": "$date"}';
  }

  // Create a DiaryEntry from a String
  factory DiaryEntry.fromString(String entryString) {
    final Map<String, String> map = {};
    final entryData = entryString
        .replaceAll(RegExp(r'["{}]'), '')
        .split(',')
        .map((e) => e.trim().split(':'))
        .toList();
    
    for (var data in entryData) {
      map[data[0].trim()] = data[1].trim();
    }

    return DiaryEntry.fromMap(map);
  }
}
