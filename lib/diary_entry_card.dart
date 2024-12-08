// diary_entry_card.dart

import 'package:flutter/material.dart';
import 'diary_entry.dart';

class DiaryEntryCard extends StatelessWidget {
  final DiaryEntry entry;
  final VoidCallback onUpdate;
  final VoidCallback onDelete;

  const DiaryEntryCard({
    required this.entry,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black54,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        title: Text(entry.title, style: const TextStyle(color: Colors.greenAccent)),
        subtitle: Text(entry.content, style: const TextStyle(color: Colors.white)),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: onDelete, // Trigger the delete function
        ),
        onTap: onUpdate, // Trigger the update function when the card is tapped
      ),
    );
  }
}
