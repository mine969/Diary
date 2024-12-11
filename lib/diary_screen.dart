import 'package:flutter/material.dart';
import 'diary_manager.dart';
import 'diary_entry.dart';
import 'diary_entry_card.dart';
import 'add_entry_page.dart'; // Import the Add Entry Page

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
    _entries = _diaryManager.getEntries(); // Load entries on init
  }

  void _deleteEntry(int index) {
    setState(() {
      _diaryManager.deleteEntry(index); // Delete entry
      _entries = _diaryManager.getEntries(); // Reload entries
    });
  }

  void _updateEntry(int index) {
    _diaryManager.getEntries().then((entries) {
      final entry = entries[index]; // Get the current entry
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AddEntryPage(
            onSave: (updatedEntry) {
              setState(() {
                _diaryManager.updateEntry(
                    index, updatedEntry); // Update the entry in the manager
                _entries = _diaryManager.getEntries(); // Reload entries
              });
              Navigator.pop(context); // Go back to the diary screen
            },
            initialTitle: entry.title, // Pass initial title
            initialContent: entry.content, // Pass initial content
            initialDate: entry.date, // Pass initial date
            isEditing: true, // Indicate that we are editing
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
              'assets/images/DiaryLogo.png'), // Ensure you have a logo in assets
        ),
        title: const Text(
          'Diary Entries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.greenAccent,
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
            icon: const Icon(Icons.add,
                color: Colors.greenAccent), // Ensure color is visible
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEntryPage(onSave: (entry) {
                    setState(() {
                      _diaryManager.addEntry(entry);
                      _entries = _diaryManager.getEntries(); // Reload entries
                    });
                  }),
                ),
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
            return Center(child: Text('Error: ${snapshot.error}'));
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
            );
          }

          final entries = snapshot.data!;

          return ListView.builder(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            itemCount: entries.length,
            itemBuilder: (context, index) {
              final entry = entries[index];
              return DiaryEntryCard(
                entry: entry,
                onDelete: () {
                  _deleteEntry(index); // Delete the entry
                },
                onUpdate: () {
                  _updateEntry(index); // Open the update page
                },
              );
            },
          );
        },
      ),
    );
  }
}
