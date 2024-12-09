import 'package:flutter/material.dart';
import 'diary_entry.dart';

class AddEntryPage extends StatefulWidget {
  final Function(DiaryEntry) onSave;
  final String? initialTitle;
  final String? initialContent;
  final DateTime? initialDate;
  final bool isEditing;  // Flag to determine if we are editing an entry

  const AddEntryPage({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialContent,
    this.initialDate,
    this.isEditing = false, // Default is false for new entry
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
        title: Text(
          widget.isEditing ? 'Edit Diary Entry' : 'Add Diary Entry',
          style: const TextStyle(
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
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.greenAccent),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _contentController,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.greenAccent),
                border: OutlineInputBorder(),
              ),
              maxLines: 6,
            ),
            const SizedBox(height: 20),
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
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: Text(
                  widget.isEditing ? 'Update Entry' : 'Save Entry',
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
