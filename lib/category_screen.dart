import 'package:flutter/material.dart';
import 'edit_note_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;
  final List<Map<String, String>> notes;
  final ThemeMode themeMode;
  final Color categoryColor;
  final Function(List<Map<String, String>>) onUpdateNotes;

  const CategoryScreen({
    Key? key,
    required this.category,
    required this.notes,
    required this.themeMode,
    required this.categoryColor,
    required this.onUpdateNotes,
  }) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  List<Map<String, String>> filteredNotes = [];
  bool isSearching = false;
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredNotes = List.from(widget.notes);
  }

  void _addNote() async {
    Map<String, String>? newNote = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        String noteTitle = '';
        String noteText = '';
        final bool isDark = widget.themeMode == ThemeMode.dark || 
            (widget.themeMode == ThemeMode.system && 
             MediaQuery.of(context).platformBrightness == Brightness.dark);
            
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text('Add ${widget.category} Note', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                onChanged: (value) => noteTitle = value,
                decoration: InputDecoration(
                  hintText: 'Enter your note title',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.white,
                  hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 10),
              TextField(
                onChanged: (value) => noteText = value,
                decoration: InputDecoration(
                  hintText: 'Enter your note',
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.white,
                  hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                ),
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: isDark ? Colors.white70 : Colors.blue)),
            ),
            ElevatedButton(
              onPressed: () {
                if (noteTitle.trim().isNotEmpty) {
                  Navigator.pop(
                    context,
                    {'title': noteTitle.trim(), 'content': noteText.trim()},
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.blueGrey[700] : widget.categoryColor,
              ),
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (newNote != null && newNote['title'] != null && newNote['title']!.isNotEmpty) {
      setState(() {
        widget.notes.add(newNote);
        filteredNotes = List.from(widget.notes);
        widget.onUpdateNotes(widget.notes);
      });
    }
  }

  void _filterNotes(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredNotes = List.from(widget.notes);
      } else {
        filteredNotes = widget.notes
            .where((note) =>
                note['title']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      if (isSearching) {
        searchController.clear();
        filteredNotes = List.from(widget.notes);
      }
      isSearching = !isSearching;
    });
  }

  void _deleteNote(int index) {
    // Get the note to delete from filtered list
    final noteToDelete = filteredNotes[index];
    
    setState(() {
      // Remove from filtered list
      filteredNotes.removeAt(index);
      
      // Remove from main list
      widget.notes.removeWhere((note) => 
          note['title'] == noteToDelete['title'] && 
          note['content'] == noteToDelete['content']);
      
      widget.onUpdateNotes(widget.notes);
    });
  }

  void _editNote(int index) async {
    final updatedNote = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteScreen(
          note: Map<String, String>.from(filteredNotes[index]),
          themeMode: widget.themeMode,
          categoryColor: widget.categoryColor,
        ),
      ),
    );

    if (updatedNote != null) {
      setState(() {
        // Find the original note in the main list and update it
        final originalNote = filteredNotes[index];
        int originalIndex = widget.notes.indexWhere((note) =>
            note['title'] == originalNote['title'] &&
            note['content'] == originalNote['content']);
        
        if (originalIndex != -1) {
          widget.notes[originalIndex] = updatedNote;
        }
        
        // Update the filtered list
        filteredNotes[index] = updatedNote;
        widget.onUpdateNotes(widget.notes);
      });
    }
  }

  Color _getAppBarColor(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || 
        (widget.themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    return isDark ? Colors.grey[900]! : widget.categoryColor;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || 
        (widget.themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    final Color appBarColor = _getAppBarColor(context);
    
    return Scaffold(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search by title...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.white70),
                ),
                style: TextStyle(color: Colors.white),
                onChanged: _filterNotes,
              )
            : Text(widget.category, style: TextStyle(color: Colors.white)),
        actions: [
          if (isSearching)
            IconButton(
              icon: Icon(Icons.clear, color: Colors.white),
              onPressed: () {
                setState(() {
                  searchController.clear();
                  filteredNotes = List.from(widget.notes);
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.search, color: Colors.white),
              onPressed: _toggleSearch,
            ),
          Padding(padding: EdgeInsets.only(right: 15))
        ],
        centerTitle: true,
        backgroundColor: appBarColor,
        elevation: 4,
      ),
      body: filteredNotes.isEmpty
          ? Center(
              child: Text(
                isSearching && widget.notes.isNotEmpty
                    ? 'No notes found with that title'
                    : 'No ${widget.category.toLowerCase()} notes yet. Tap + to add one!',
                style: TextStyle(
                  color: isDark ? Colors.white70 : Colors.grey[700],
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              itemCount: filteredNotes.length,
              itemBuilder: (context, index) => Card(
                margin: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: isDark ? Colors.grey[800] : widget.categoryColor,
                elevation: 2,
                child: Container(
                  height: 120,
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              filteredNotes[index]['title'] ?? 'No Title',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                overflow: TextOverflow.ellipsis,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                            ),
                            SizedBox(height: 8),
                            Expanded(
                              child: Text(
                                filteredNotes[index]['content'] ?? '',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white70,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.white, size: 22),
                            onPressed: () => _editNote(index),
                          ),
                          IconButton(
                            icon: Icon(Icons.delete, color: Colors.white, size: 22),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: appBarColor,
      ),
    );
  }
}