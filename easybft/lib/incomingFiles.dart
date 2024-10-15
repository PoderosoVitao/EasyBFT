import 'package:flutter/material.dart';
import 'package:all_bluetooth/all_bluetooth.dart';

class IncomingFilesScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final dynamic allBluetooth;

  const IncomingFilesScreen({required this.toggleTheme, required this.isDarkMode, required this.allBluetooth, Key? key}) : super(key: key);

  @override
  _IncomingFilesScreenState createState() => _IncomingFilesScreenState();
}

class _IncomingFilesScreenState extends State<IncomingFilesScreen> {
  List<Map<String, dynamic>> incomingFiles = [];

  // Placeholder de Download. Ainda vamos adicionar isso.
  void _downloadFile(int index) {
    final file = incomingFiles[index];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Downloading ${file['name']}')),
    );
  }

  Widget _buildFileIcon(String type) {
    switch (type) {
      case 'pdf':
        return const Icon(Icons.picture_as_pdf, color: Colors.red, size: 40);
      case 'image':
        return const Icon(Icons.image, color: Colors.grey, size: 40);
      default:
        return const Icon(Icons.insert_drive_file, color: Colors.grey, size: 40);
    }
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
              '${incomingFiles.length} arquivos recebidos',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: incomingFiles.length,
              itemBuilder: (context, index) {
                final file = incomingFiles[index];
                return ListTile(
                  leading: _buildFileIcon(file['type']),
                  title: Text(file['name']),
                  subtitle: Text(file['size']),
                  trailing: IconButton(
                    icon: const Icon(Icons.download),
                    onPressed: () => _downloadFile(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
