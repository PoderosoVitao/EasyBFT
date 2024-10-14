import 'package:flutter/material.dart';
import 'uploadedFiles.dart';
import 'incomingFiles.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  List<Widget> _screens() {
    return [
      FileShareScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
      IncomingFilesScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
      ),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy BFT',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _screens()[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.upload_file),
              label: 'Uploaded Files',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.download),
              label: 'Incoming Files',
            ),
          ],
        ),
      ),
    );
  }
}
