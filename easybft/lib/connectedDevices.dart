import 'dart:async';

import 'package:flutter/material.dart';
import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:permission_handler/permission_handler.dart';

class ConnectedDevicesScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final AllBluetooth allBluetooth;

  const ConnectedDevicesScreen({required this.toggleTheme, required this.isDarkMode, required this.allBluetooth, Key? key}) : super(key: key);

  @override
  _ConnectedDevicesScreenState createState() => _ConnectedDevicesScreenState();
}

class _ConnectedDevicesScreenState extends State<ConnectedDevicesScreen> {
  List<BluetoothDevice> availableDevices = [];
  bool _isDiscovering = false;
  late StreamSubscription<BluetoothDevice> _discoverySubscription; // Subscription for device discovery stream

  @override
  void initState() {
    super.initState();
    _requestPermissions().then((_) {
      _startDiscovery();
    });
  }

  /// QUE DOR DE CABEÇA
  // Demorei pra descobrir que precisamos pedir essas permissoes durante runtime
  // e não apenas no androidmanifest.xml
  Future<void> _requestPermissions() async {
    if (await Permission.bluetoothScan.isDenied) {
      await Permission.bluetoothScan.request();
    }
    if (await Permission.bluetoothConnect.isDenied) {
      await Permission.bluetoothConnect.request();
    }
    if (await Permission.location.isDenied) {
      await Permission.location.request();
    }
    if (await Permission.bluetoothAdvertise.isDenied) {
      await Permission.bluetoothAdvertise.request();
    }
  }


  @override
  void dispose() {
    _stopDiscovery();
    super.dispose();
  }

  void _startDiscovery() async {
    setState(() {
      _isDiscovering = true;
      availableDevices.clear();
    });

    try {
      print("Starting Bluetooth discovery...");
      await widget.allBluetooth.startDiscovery();
      print("Discovery started!");

      _discoverySubscription = widget.allBluetooth.discoverDevices.listen(
            (BluetoothDevice device) {
          setState(() {
            if (!availableDevices.any((d) => d.address == device.address)) {
              availableDevices.add(device);
              print("Discovered device: ${device.name} (${device.address})");
            }
          });
        },
        onError: (error) {
          print("Error during discovery: $error");
          setState(() {
            _isDiscovering = false;
          });
        },
        onDone: () {
          print("Discovery completed.");
          setState(() {
            _isDiscovering = false;
          });
        },
      );
    } catch (e) {
      print("Failed to start discovery: $e");
      setState(() {
        _isDiscovering = false;
      });
    }
  }
  void _stopDiscovery() {
    widget.allBluetooth.stopDiscovery();
    _discoverySubscription.cancel();
    setState(() {
      _isDiscovering = false;
    });
  }
  Widget _buildDeviceItem(BluetoothDevice device) {
    return ListTile(
      leading: Icon(Icons.devices),
      title: Text(device.name ?? 'Unknown Device'),
      subtitle: Text(device.address),  // Aqui no caso mostramos o endereço MAC
      onTap: () {
        // Ainda tenho que adicionar a lógica de pareamento.
        print('Clicked on device: ${device.name}');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 40,
            ),
            const SizedBox(width: 10),
            const Text('Easy BFT'),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Toggle Dark Mode') {
                widget.toggleTheme();
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Toggle Dark Mode'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _isDiscovering
                  ? 'Discovering devices...'
                  : 'Tap a device to connect',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: availableDevices.length,
              itemBuilder: (context, index) {
                return _buildDeviceItem(availableDevices[index]);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_isDiscovering) {
            _stopDiscovery();
          } else {
            _startDiscovery();
          }
        },
        backgroundColor: _isDiscovering ? Colors.red : Colors.green,
        child: Icon(
          _isDiscovering ? Icons.stop : Icons.play_arrow,
        ),
      ),
    );
  }
}
