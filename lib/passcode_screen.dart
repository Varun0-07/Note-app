import 'package:flutter/material.dart';

enum PasscodeMode { set, verify, change }

class PasscodeScreen extends StatefulWidget {
  final PasscodeMode mode;
  final String? currentPasscode;
  final ThemeMode themeMode;

  const PasscodeScreen({
    Key? key,
    required this.mode,
    this.currentPasscode,
    required this.themeMode,
  }) : super(key: key);

  @override
  _PasscodeScreenState createState() => _PasscodeScreenState();
}

class _PasscodeScreenState extends State<PasscodeScreen> {
  String enteredPasscode = '';
  String newPasscode = '';
  String confirmPasscode = '';
  bool isConfirming = false;
  bool showError = false;
  String errorMessage = '';

  void _onNumberPressed(String number) {
    if (enteredPasscode.length < 4) {
      setState(() {
        enteredPasscode += number;
        showError = false;
      });

      if (enteredPasscode.length == 4) {
        _processPasscode();
      }
    }
  }

  void _onBackspacePressed() {
    if (enteredPasscode.isNotEmpty) {
      setState(() {
        enteredPasscode = enteredPasscode.substring(0, enteredPasscode.length - 1);
        showError = false;
      });
    }
  }

  void _processPasscode() {
    switch (widget.mode) {
      case PasscodeMode.verify:
        if (enteredPasscode == widget.currentPasscode) {
          Navigator.pop(context, true);
        } else {
          setState(() {
            showError = true;
            errorMessage = 'Incorrect passcode';
            enteredPasscode = '';
          });
        }
        break;
      
      case PasscodeMode.set:
        if (!isConfirming) {
          setState(() {
            newPasscode = enteredPasscode;
            enteredPasscode = '';
            isConfirming = true;
          });
        } else {
          if (enteredPasscode == newPasscode) {
            Navigator.pop(context, enteredPasscode);
          } else {
            setState(() {
              showError = true;
              errorMessage = 'Passcodes do not match';
              enteredPasscode = '';
              isConfirming = false;
            });
          }
        }
        break;
      
      case PasscodeMode.change:
        if (!isConfirming) {
          if (enteredPasscode == widget.currentPasscode) {
            setState(() {
              enteredPasscode = '';
              isConfirming = true;
            });
          } else {
            setState(() {
              showError = true;
              errorMessage = 'Incorrect current passcode';
              enteredPasscode = '';
            });
          }
        } else if (newPasscode.isEmpty) {
          setState(() {
            newPasscode = enteredPasscode;
            enteredPasscode = '';
          });
        } else {
          if (enteredPasscode == newPasscode) {
            Navigator.pop(context, enteredPasscode);
          } else {
            setState(() {
              showError = true;
              errorMessage = 'Passcodes do not match';
              enteredPasscode = '';
              newPasscode = '';
              isConfirming = false;
            });
          }
        }
        break;
    }
  }

  String _getTitle() {
    switch (widget.mode) {
      case PasscodeMode.verify:
        return 'Enter Passcode';
      case PasscodeMode.set:
        return isConfirming ? 'Confirm Passcode' : 'Set Passcode';
      case PasscodeMode.change:
        if (!isConfirming) return 'Enter Current Passcode';
        if (newPasscode.isEmpty) return 'Enter New Passcode';
        return 'Confirm New Passcode';
    }
  }

  Color _getAppBarColor(BuildContext context) {
    final bool isDark = widget.themeMode == ThemeMode.dark || 
        (widget.themeMode == ThemeMode.system && 
         MediaQuery.of(context).platformBrightness == Brightness.dark);
    
    return isDark ? Colors.grey[900]! : Color(0xFF2E4057);
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
        title: Text(_getTitle(), style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: appBarColor,
        elevation: 4,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Passcode dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < enteredPasscode.length
                        ? appBarColor
                        : isDark ? Colors.grey[700] : Colors.grey[300],
                  ),
                );
              }),
            ),
            
            SizedBox(height: 20),
            
            // Error message
            if (showError)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            
            SizedBox(height: 40),
            
            // Number pad
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [1, 2, 3].map((number) {
                    return _NumberButton(
                      number: number.toString(),
                      onPressed: _onNumberPressed,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [4, 5, 6].map((number) {
                    return _NumberButton(
                      number: number.toString(),
                      onPressed: _onNumberPressed,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [7, 8, 9].map((number) {
                    return _NumberButton(
                      number: number.toString(),
                      onPressed: _onNumberPressed,
                      isDark: isDark,
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.all(8),
                    ),
                    _NumberButton(
                      number: '0',
                      onPressed: _onNumberPressed,
                      isDark: isDark,
                    ),
                    Container(
                      width: 80,
                      height: 80,
                      margin: EdgeInsets.all(8),
                      child: IconButton(
                        icon: Icon(Icons.backspace, size: 28),
                        onPressed: _onBackspacePressed,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  final String number;
  final Function(String) onPressed;
  final bool isDark;

  const _NumberButton({
    required this.number,
    required this.onPressed,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      margin: EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () => onPressed(number),
        child: Text(
          number,
          style: TextStyle(fontSize: 24, color: isDark ? Colors.white : Colors.black),
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          backgroundColor: isDark ? Colors.grey[800] : Colors.grey[200],
        ),
      ),
    );
  }
}