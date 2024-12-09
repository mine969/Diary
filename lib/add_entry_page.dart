import 'package:flutter/material.dart';
import 'diary_entry.dart';

class AddEntryPage extends StatefulWidget {
  final Function(DiaryEntry) onSave;
  final String? initialTitle;
  final String? initialContent;
  final DateTime? initialDate;
  final bool isEditing; // Flag to check if editing an existing entry

  const AddEntryPage({
    super.key,
    required this.onSave,
    this.initialTitle,
    this.initialContent,
    this.initialDate,
    this.isEditing = false,
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

  void _saveEntry() {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      // Show a warning if title or content is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Title and content cannot be empty')),
      );
      return;
    }

    final entry = DiaryEntry(
      title: _titleController.text,
      content: _contentController.text,
      date: widget.initialDate ?? DateTime.now(),
    );

    widget.onSave(entry);  // Pass the updated or new entry to the parent
    Navigator.pop(context);  // Go back to the previous screen
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
            icon: const Icon(Icons.save, color: Colors.greenAccent),
            onPressed: _saveEntry,  // Call save method
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
                onPressed: _saveEntry,  // Call save method
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                ),
                child: const Text(
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
