import 'package:all_bluetooth/all_bluetooth.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class FileShareScreen extends StatefulWidget {
  final VoidCallback toggleTheme;
  final bool isDarkMode;
  final dynamic allBluetooth;

  const FileShareScreen({required this.toggleTheme, required this.isDarkMode, required this.allBluetooth, Key? key}) : super(key: key);

  @override
  _FileShareScreenState createState() => _FileShareScreenState();
}

class _FileShareScreenState extends State<FileShareScreen> {
  List<Map<String, dynamic>> sharedFiles = [];

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        sharedFiles.add({
          'name': file.name,
          'size': _correctSize(file.size),
          'type': file.extension ?? 'file',
          //'path': file.path
        });
      });
    }
  }

  String _correctSize(int size){
    String returnStr = "0kb";
    if(size < 1024)returnStr = '${(size).toStringAsFixed(1)}b';
    else if (size >= 1024)
    {
      double sizeD = size / 1024.0;
      returnStr = '${(sizeD).toStringAsFixed(1)}kb';
      if(sizeD > 1024)
      {
        sizeD = sizeD / 1024.0;
        returnStr = '${(sizeD).toStringAsFixed(1)}mb';
        if(sizeD > 1024)
        {
          sizeD = sizeD / 1024.0;
          returnStr = '${(sizeD).toStringAsFixed(1)}gb';
        }
      }
    }
    
    return returnStr;
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
              '${sharedFiles.length} arquivos compartilhados',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: sharedFiles.length,
              itemBuilder: (context, index) {
                final file = sharedFiles[index];
                return ListTile(
                  leading: _buildFileIcon(file['type']),
                  title: Text(file['name']),
                  subtitle: Text(file['size']),
                  trailing: IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      setState(() {
                        sharedFiles.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton.icon(
            onPressed: _pickFile,
            icon: const Icon(Icons.upload_file),
            label: const Text('Selecionar Arquivo'),
          ),
        ),
      ),
    );
  }
}
