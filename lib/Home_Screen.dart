import 'package:flutter/material.dart';
import 'category_screen.dart';
import 'passcode_screen.dart';
import 'CalendarNoteScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Theme mode state
  ThemeMode _themeMode = ThemeMode.light;

  // Categories with their respective note lists
  Map<String, List<Map<String, String>>> categories = {
    'Personal': [],
    'Work': [],
    'Fun': [],
    'Calendar': [],
    'Secret': [],
  };

  // Passcode state
  String? secretPasscode;

  // Category images (using emoji as placeholders - replace with actual PNG assets)
  final Map<String, String> categoryImages = {
    'Personal': '😊',
    'Work': '💼',
    'Fun': '🎮',
    'Calendar': '📅',
    'Secret': '🔒',
  };

  final Map<String, Color> categoryColors = {
    'Personal': Color(0xFF6DAED6),
    'Work': Color(0xFFF18F01),
    'Fun': Color(0xFFC73E1D),
    'Calendar': Color(0xFF2A9D8F),
    'Secret': Color(0xFF2E4057),
  };

  @override
  void initState() {
    super.initState();
    // Load passcode from storage (in a real app, use secure storage)
    // For demo purposes, we'll just initialize as null
  }

  void _showThemeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final bool isDark = _themeMode == ThemeMode.dark || 
            (_themeMode == ThemeMode.system && 
             MediaQuery.of(context).platformBrightness == Brightness.dark);
            
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text("Select Theme", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.light_mode, color: isDark ? Colors.white : Colors.black),
                title: Text("Light Theme", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  setState(() {
                    _themeMode = ThemeMode.light;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.dark_mode, color: isDark ? Colors.white : Colors.black),
                title: Text("Dark Theme", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  setState(() {
                    _themeMode = ThemeMode.dark;
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.auto_awesome, color: isDark ? Colors.white : Colors.black),
                title: Text("System Default", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  setState(() {
                    _themeMode = ThemeMode.system;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showSettingsDialog() {
    final bool isDark = _themeMode == ThemeMode.dark || 
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text("Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.lock, color: isDark ? Colors.white : Colors.black),
                title: Text("Passcode Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _showPasscodeSettings();
                },
              ),
              ListTile(
                leading: Icon(Icons.color_lens, color: isDark ? Colors.white : Colors.black),
                title: Text("Theme Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                onTap: () {
                  Navigator.pop(context);
                  _showThemeDialog();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPasscodeSettings() {
    final bool isDark = _themeMode == ThemeMode.dark || 
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text("Passcode Settings", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (secretPasscode == null)
                ListTile(
                  leading: Icon(Icons.lock_open, color: isDark ? Colors.white : Colors.black),
                  title: Text("Set Passcode", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    _setPasscode();
                  },
                )
              else
                ListTile(
                  leading: Icon(Icons.lock, color: isDark ? Colors.white : Colors.black),
                  title: Text("Change Passcode", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                  onTap: () {
                    Navigator.pop(context);
                    _changePasscode();
                  },
                ),
              if (secretPasscode != null)
                ListTile(
                  leading: Icon(Icons.lock_open, color: Colors.orange),
                  title: Text("Remove Passcode", style: TextStyle(color: Colors.orange)),
                  onTap: () {
                    Navigator.pop(context);
                    _showRemoveWarning();
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _setPasscode() async {
    final String? newPasscode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          mode: PasscodeMode.set,
          themeMode: _themeMode,
        ),
      ),
    );

    if (newPasscode != null) {
      setState(() {
        secretPasscode = newPasscode;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passcode set successfully')),
      );
    }
  }

  void _changePasscode() async {
    final String? newPasscode = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PasscodeScreen(
          mode: PasscodeMode.change,
          currentPasscode: secretPasscode,
          themeMode: _themeMode,
        ),
      ),
    );

    if (newPasscode != null) {
      setState(() {
        secretPasscode = newPasscode;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passcode changed successfully')),
      );
    }
  }

  void _showRemoveWarning() {
    final bool isDark = _themeMode == ThemeMode.dark || 
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: isDark ? Colors.grey[900] : Colors.white,
          title: Text("Warning", style: TextStyle(color: Colors.orange)),
          content: Text(
            "Removing passcode will delete all notes in the Secret category. This action cannot be undone.",
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: isDark ? Colors.white : Colors.black)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("Remove", style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    ).then((value) {
      if (value == true) {
        _removePasscode();
      }
    });
  }

  void _removePasscode() {
    // Clear the current passcode and secret notes
    setState(() {
      secretPasscode = null;
      categories['Secret'] = []; // Clear all secret notes
    });
    
    // Show a confirmation message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Passcode removed and secret notes cleared.')),
    );
  }

  void _openCategory(String category) async {
    if (category == 'Secret' && secretPasscode != null) {
      // Verify passcode before accessing secret category
      final bool verified = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PasscodeScreen(
            mode: PasscodeMode.verify,
            currentPasscode: secretPasscode,
            themeMode: _themeMode,
          ),
        ),
      );

      if (!verified) {
        return; // Don't open category if passcode is incorrect
      }
    }

    Widget screen;
    if (category == 'Calendar') {
      screen = CalendarNoteScreen(
        category: category,
        notes: categories[category]!,
        themeMode: _themeMode,
        categoryColor: categoryColors[category]!,
        onUpdateNotes: (updatedNotes) {
          setState(() {
            categories[category] = updatedNotes;
          });
        },
      );
    } else {
      screen = CategoryScreen(
        category: category,
        notes: categories[category]!,
        themeMode: _themeMode,
        categoryColor: categoryColors[category]!,
        onUpdateNotes: (updatedNotes) {
          setState(() {
            categories[category] = updatedNotes;
          });
        },
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  Color _getAppBarColor(BuildContext context) {
    final bool isDark = _themeMode == ThemeMode.dark || 
        (_themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    return isDark ? Colors.grey[900]! : Color(0xFF6DAED6);
  }

  @override
  Widget build(BuildContext context) {
    // Determine current theme based on theme mode
    final bool isDark = _themeMode == ThemeMode.dark || 
        (_themeMode == ThemeMode.system && 
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
      themeMode: _themeMode,
      home: Scaffold(
        backgroundColor: isDark ? Colors.grey[900] : Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {},
          ),
          title: Text('Knot Note', style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: appBarColor,
          elevation: 4,
          actions: [
            IconButton(
              icon: Icon(Icons.settings, color: Colors.white),
              onPressed: _showSettingsDialog,
            ),
            Padding(padding: EdgeInsets.only(right: 15))
          ],
        ),
        body: GridView.count(
          crossAxisCount: 2,
          padding: EdgeInsets.all(16),
          children: categories.keys.map((category) {
            return GestureDetector(
              onTap: () => _openCategory(category),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                color: isDark ? Colors.grey[800] : categoryColors[category],
                child: Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        categoryImages[category]!,
                        style: TextStyle(fontSize: 40),
                      ),
                      SizedBox(height: 10),
                      Text(
                        category,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        '${categories[category]!.length} notes',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),
                      if (category == 'Secret' && secretPasscode != null)
                        Icon(Icons.lock, size: 16, color: Colors.white70),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}