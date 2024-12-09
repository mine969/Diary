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

  // Function to show the dialog and edit the entry inline
  void _editEntryInline(int index) {
    _diaryManager.getEntries().then((entries) {
      final entry = entries[index]; // Get the current entry
      TextEditingController titleController =
          TextEditingController(text: entry.title);
      TextEditingController contentController =
          TextEditingController(text: entry.content);

      // Show full-screen modal bottom sheet for editing
      showModalBottomSheet(
        context: context,
        isScrollControlled: true, // Make the sheet full screen
        backgroundColor: Colors.black, // Transparent background
        builder: (BuildContext context) {
          return GestureDetector(
            onTap: () {
              // Automatically save when tapping outside the input area
              final updatedEntry = DiaryEntry(
                title: titleController.text,
                content: contentController.text,
                date: entry.date, // Keep the original date
                imagePath:
                    entry.imagePath, // Keep the original imagePath if any
              );

              setState(() {
                _diaryManager.updateEntry(index, updatedEntry); // Update entry
                _entries = _diaryManager.getEntries(); // Reload entries
              });

              Navigator.pop(context); // Close the modal
            },
            child: GestureDetector(
              onTap:
                  () {}, // Prevent taps inside the input area from closing the modal
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 8, 8, 8), // Dark background
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    // Title input
                    TextField(
                      controller: titleController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Title',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Content input
                    TextField(
                      controller: contentController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Content',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 10,
                    ),
                    const SizedBox(height: 20),
                    // Save button at the bottom
                    ElevatedButton(
                      onPressed: () {
                        // Manually save the changes when the Save button is pressed
                        final updatedEntry = DiaryEntry(
                          title: titleController.text,
                          content: contentController.text,
                          date: entry.date, // Keep the original date
                          imagePath: entry
                              .imagePath, // Keep the original imagePath if any
                        );

                        setState(() {
                          _diaryManager.updateEntry(
                              index, updatedEntry); // Update entry
                          _entries =
                              _diaryManager.getEntries(); // Reload entries
                        });

                        Navigator.pop(context); // Close the modal after saving
                      },
                      child: const Text('Save'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                            255, 40, 43, 41), // Save button color
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        textStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ).then((_) {
        // Auto-save when modal is dismissed (if the user taps outside)
        final updatedEntry = DiaryEntry(
          title: titleController.text,
          content: contentController.text,
          date: entry.date, // Keep the original date
          imagePath: entry.imagePath, // Keep the original imagePath if any
        );

        setState(() {
          _diaryManager.updateEntry(index, updatedEntry); // Update entry
          _entries = _diaryManager.getEntries(); // Reload entries
        });
      });
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
            icon: const Icon(Icons.add, color: Colors.greenAccent),
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
            return const Center(child: Text('No entries yet.'));
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
                  _editEntryInline(index); // Open the full-screen inline edit
                },
              );
            },
          );
        },
      ),
    );
  }
}
