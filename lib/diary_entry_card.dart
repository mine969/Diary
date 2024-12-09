import 'package:flutter/material.dart';
import 'diary_entry.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onDelete;
  final VoidCallback onUpdate; // This is the update callback

  const DiaryEntryCard({
    Key? key,
    required this.entry,
    required this.onDelete,
    required this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 5,
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Text(
          entry.title,
          style: const TextStyle(
            color: Colors.greenAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          entry.content,
          style: const TextStyle(color: Colors.white),
        ),
        onTap: onUpdate, // This triggers the onUpdate function when the entry is tapped
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete, // This triggers delete when clicked
        ),
      ),
    );
  }
}
