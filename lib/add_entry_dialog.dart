// add_entry_dialog.dart

import 'package:flutter/material.dart';
import 'diary_entry.dart';

class AddEntryDialog extends StatefulWidget {
  final Function(DiaryEntry) onSave;
  final String? initialTitle;
  final String? initialContent;
  final String? initialDate;

  const AddEntryDialog({
    required this.onSave,
    this.initialTitle,
    this.initialContent,
    this.initialDate,
  });

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.initialTitle != null) {
      _titleController.text = widget.initialTitle!;
      _contentController.text = widget.initialContent!;
      _dateController.text = widget.initialDate!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New Diary Entry'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          TextField(
            controller: _contentController,
            decoration: const InputDecoration(hintText: 'Content'),
          ),
          TextField(
            controller: _dateController,
            decoration: const InputDecoration(hintText: 'Date'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            // Validate the fields
            if (_titleController.text.isEmpty ||
                _contentController.text.isEmpty ||
                _dateController.text.isEmpty) {
              // Show an error if any field is empty
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Error'),
                    content: const Text('All fields must be filled!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            } else {
              final entry = DiaryEntry(
                title: _titleController.text,
                content: _contentController.text,
                date: _dateController.text,
              );
              widget.onSave(entry);
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
