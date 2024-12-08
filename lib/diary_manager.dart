import 'dart:io';
import 'package:flutter/services.dart';  // For accessing assets
import 'package:path_provider/path_provider.dart';  // For writable file path
import 'diary_entry.dart';

class DiaryManager {
  static const String assetFilePath = 'assets/datas/diary_entries.txt';  // Path to the asset file
  late File _file;  // The writable file

  // Initialize the file path for writable location (app's documents directory)
  Future<void> _initializeFile() async {
    final directory = await getApplicationDocumentsDirectory(); // Get app document directory
    _file = File('${directory.path}/diary_entries.txt');  // Save file in app documents directory
  }

  // READ: Get all diary entries (from assets, then write to writable file)
  Future<List<DiaryEntry>> getEntries() async {
    try {
      // Read the file content from the assets folder
      final String data = await rootBundle.loadString(assetFilePath);  
      List<DiaryEntry> entries = _parseEntries(data);
      
      // Initialize file for writing and copy data to writable directory
      await _initializeFile();
      await _file.writeAsString(data);  // Write the data to the writable file

      return entries;  // Return the parsed entries from the text
    } catch (e) {
      print('Error reading file: $e');
      return [];  // Return an empty list if an error occurs
    }
  }

  // Parse the raw text data into diary entries
  List<DiaryEntry> _parseEntries(String data) {
    List<DiaryEntry> entries = [];
    final entryStrings = data.split('\n');
    for (var entryString in entryStrings) {
      if (entryString.isNotEmpty) {
        entries.add(DiaryEntry.fromString(entryString));  // Convert each line into a DiaryEntry object
      }
    }
    return entries;
  }

  // CREATE: Add a new diary entry
  Future<void> addEntry(DiaryEntry entry) async {
    try {
      await _initializeFile();  // Initialize the file path for writable storage
      await _file.writeAsString(entry.toString() + '\n', mode: FileMode.append);  // Append new entry to the file
    } catch (e) {
      print('Error writing to file: $e');  // Print error if the file write fails
    }
  }

  // UPDATE: Modify an existing diary entry
  Future<void> updateEntry(int index, DiaryEntry updatedEntry) async {
    try {
      final entries = await getEntries();  // Get current entries from file
      entries[index] = updatedEntry;  // Update the specific entry

      await _file.writeAsString('', mode: FileMode.writeOnly);  // Clear the file contents

      // Write all updated entries back to the file
      for (var entry in entries) {
        await _file.writeAsString(entry.toString() + '\n', mode: FileMode.append);
      }
    } catch (e) {
      print('Error updating file: $e');  // Print error if the file update fails
    }
  }

  // DELETE: Remove a diary entry
  Future<void> deleteEntry(int index) async {
    try {
      final entries = await getEntries();  // Get current entries from file
      entries.removeAt(index);  // Remove the entry at the specified index

      await _file.writeAsString('', mode: FileMode.writeOnly);  // Clear the file contents

      // Write the remaining entries back to the file
      for (var entry in entries) {
        await _file.writeAsString(entry.toString() + '\n', mode: FileMode.append);
      }
    } catch (e) {
      print('Error deleting from file: $e');  // Print error if the file deletion fails
    }
  }
}
