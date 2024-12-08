import 'package:flutter/material.dart';
import 'diary_manager.dart';
import 'diary_entry.dart';
import 'add_entry_dialog.dart';
import 'diary_entry_card.dart';

class DiaryScreen extends StatefulWidget {
  const DiaryScreen({super.key});

  @override
  _DiaryScreenState createState() => _DiaryScreenState();
}

class _DiaryScreenState extends State<DiaryScreen> {
  final DiaryManager _diaryManager = DiaryManager();
  late Future<List<DiaryEntry>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = _diaryManager.getEntries();  // Load entries on init
  }

  void _addEntry(DiaryEntry entry) {
    setState(() {
      _diaryManager.addEntry(entry);  // Add entry to file
      _entries = _diaryManager.getEntries();  // Reload entries
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: const Text(
          'Diary Entries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.greenAccent,  // Neon green title for hacker theme
            shadows: [
              Shadow(
                blurRadius: 10.0,
                color: Colors.greenAccent,
                offset: Offset(0, 0),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AddEntryDialog(onSave: _addEntry);  // Show dialog to add entry
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<DiaryEntry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));  // Show error if there's an issue
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No entries yet.',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );  // Show if no entries
          }

          final entries = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return DiaryEntryCard(
                entry: entry,
                onUpdate: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AddEntryDialog(
                        initialTitle: entry.title,
                        initialContent: entry.content,
                        initialDate: entry.date,
                        onSave: (updatedEntry) {
                          _diaryManager.updateEntry(index, updatedEntry);
                          setState(() {
                            _entries = _diaryManager.getEntries();  // Reload entries
                          });
                        },
                      );
                    },
                  );
                },
                onDelete: () {
                  _diaryManager.deleteEntry(index);
                  setState(() {
                    _entries = _diaryManager.getEntries();  // Reload entries
                  });
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AddEntryDialog(onSave: _addEntry);  // Show dialog to add entry
            },
          );
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.greenAccent,  // Neon green button for a hacker look
      ),
    );
  }
}
