import 'package:flutter/material.dart';

class EditNoteScreen extends StatefulWidget {
  final Map<String, String> note;
  final ThemeMode themeMode;
  final Color categoryColor;

  const EditNoteScreen({
    Key? key,
    required this.note,
    required this.themeMode,
    required this.categoryColor,
  }) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  Color _getAppBarColor(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || 
        (widget.themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    return isDark ? Colors.grey[900]! : widget.categoryColor;
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note['title']);
    _contentController = TextEditingController(text: widget.note['content']);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || 
        (widget.themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    final Color appBarColor = _getAppBarColor(context);
    
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: Colors.white,
      ),
      darkTheme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.grey[900],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey[900],
        ),
      ),
      themeMode: widget.themeMode,
      home: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Edit Note', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: appBarColor,
          elevation: 4,
          actions: [
            IconButton(
              icon: Icon(Icons.save, color: Colors.white),
              onPressed: () {
                if (_titleController.text.trim().isNotEmpty) {
                  Navigator.pop(context, {
                    'title': _titleController.text.trim(),
                    'content': _contentController.text.trim(),
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Title cannot be empty'),
                      backgroundColor: appBarColor,
                    ),
                  );
                }
              },
            ),
            Padding(padding: EdgeInsets.only(right: 15)),
          ],
        ),
        body: Container(
          color: isDark ? Colors.grey[900] : Colors.white,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: 'Note title',
                  border: OutlineInputBorder(),
                  labelText: 'Title',
                  labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                  hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                  filled: true,
                  fillColor: isDark ? Colors.grey[800] : Colors.white,
                ),
                style: TextStyle(
                  fontSize: 20, 
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Note content',
                    border: OutlineInputBorder(),
                    labelText: 'Content',
                    labelStyle: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
                    hintStyle: TextStyle(color: isDark ? Colors.white60 : Colors.grey),
                    filled: true,
                    fillColor: isDark ? Colors.grey[800] : Colors.white,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}