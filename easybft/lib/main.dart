import 'dart:async';

import 'package:flutter/material.dart';
import 'uploadedFiles.dart';
import "package:all_bluetooth/all_bluetooth.dart";
import 'incomingFiles.dart';
import 'connectedDevices.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  int _selectedIndex = 0;

  final _allBluetooth = AllBluetooth();
  bool _isBluetoothOn = false;
  StreamSubscription<bool>? _bluetoothStateSubscription;
  StreamSubscription<ConnectionResult>? _connectionResultSubscription;

  @override
  void initState() {
    super.initState();
    _checkBluetoothState();
    _listenToConnectionChanges();
  }

  @override
  void dispose() {
    _bluetoothStateSubscription?.cancel();
    _connectionResultSubscription?.cancel();
    super.dispose();
  }

  void _checkBluetoothState() {
    _bluetoothStateSubscription = _allBluetooth.streamBluetoothState.listen((isBluetoothOn) {
      if (isBluetoothOn != _isBluetoothOn) {
        setState(() {
          _isBluetoothOn = isBluetoothOn;
        });
      }
    });
  }
  void _listenToConnectionChanges() {
    _connectionResultSubscription = _allBluetooth.listenForConnection.listen((connectionResult) {
      _onConnectionResultChanged(connectionResult);
    });
  }
  void _onConnectionResultChanged(ConnectionResult result) {
    print('Bluetooth Status: $result');
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  List<Widget> _screens() {
    return [
      ConnectedDevicesScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
        allBluetooth: _allBluetooth,
      ),
      FileShareScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
        allBluetooth: _allBluetooth,
      ),
      IncomingFilesScreen(
        toggleTheme: _toggleTheme,
        isDarkMode: _isDarkMode,
        allBluetooth: _allBluetooth,
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
      debugShowCheckedModeBanner: false,
      title: 'Easy BFT',
      theme: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      home: Scaffold(
        body: _screens()[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.mobile_off),
              label: 'Connect to Devices',
              ),
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
