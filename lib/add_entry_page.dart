import 'package:flutter/material.dart';
import 'diary_entry.dart';

class AddEntryPage extends StatefulWidget {
  final Function(DiaryEntry) onSave;
  final String? initialTitle;
  final String? initialContent;
  final DateTime? initialDate;

  const AddEntryPage({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialContent,
    this.initialDate,
  });

  @override
  _AddEntryPageState createState() => _AddEntryPageState();
}

class _AddEntryPageState extends State<AddEntryPage> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Add Diary Entry',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.greenAccent,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              final entry = DiaryEntry(
                title: _titleController.text,
                content: _contentController.text,
                date: widget.initialDate ?? DateTime.now(),
              );
              widget.onSave(entry); // Save the entry using the callback
              Navigator.pop(context);  // Return to the previous screen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.greenAccent),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _contentController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.greenAccent),
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  final entry = DiaryEntry(
                    title: _titleController.text,
                    content: _contentController.text,
                    date: widget.initialDate ?? DateTime.now(),
                  );
                  widget.onSave(entry);
                  Navigator.pop(context);  // Go back to the diary screen
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Use backgroundColor instead of primary
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text(
                  'Save Entry',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
