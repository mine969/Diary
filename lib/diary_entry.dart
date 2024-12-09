class DiaryEntry {
  String title;
  String content;
  DateTime date;
  String? imagePath;

  DiaryEntry({
    required this.title,
    required this.content,
    required this.date,
    this.imagePath,
  });
}
