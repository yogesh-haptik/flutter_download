// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:io';

import 'package:android_path_provider/android_path_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  await FlutterDownloader.initialize();
  FlutterDownloader.registerCallback(TestClass.callback);
  runApp(MyApp());
}

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Material App',
      home: ScreenOne(),
    );
  }
}

class ScreenOne extends StatelessWidget {
  const ScreenOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: const Placeholder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final directory = await getExternalDirectory();

          await FlutterDownloader.enqueue(
            url: _url,
            savedDir: directory!.path,
            showNotification: true,
            fileName: 'test.jpg',
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Downloaded'),
            ),
          );
        },
      ),
    );
  }
}

const _url =
    'https://upload.wikimedia.org/wikipedia/commons/6/60/The_Organ_at_Arches_National_Park_Utah_Corrected.jpg';

// Future<String?> _findLocalPath() async {
//   var externalStorageDirPath;
//   if (Platform.isAndroid) {
//     try {
//       externalStorageDirPath = await AndroidPathProvider.downloadsPath;
//     } catch (e) {
//       final directory = await getExternalStorageDirectory();
//       externalStorageDirPath = directory?.path;
//     }
//   } else if (Platform.isIOS) {
//     externalStorageDirPath =
//         (await getApplicationDocumentsDirectory()).absolute.path;
//   }
//   return externalStorageDirPath;
// }

Future<Directory?> getExternalDirectory() async {
  if (Platform.isAndroid)
    try {
      final _androidPath = await AndroidPathProvider.downloadsPath;

      final _directory = Directory(_androidPath);

      if (await _directory.exists()) return _directory;

      return getExternalDirectory();
    } catch (e) {
      return getExternalDirectory();
    }

  if (Platform.isIOS) return getApplicationDocumentsDirectory();

  return null;
}
