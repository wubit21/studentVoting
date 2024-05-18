import 'package:finalproj/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:finalproj/firebase_service.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class directorPage extends StatefulWidget {
  @override
  _directorPageState createState() => _directorPageState();
}

class _directorPageState extends State<directorPage> {
  final TextEditingController _datacontroller = TextEditingController();
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref().child('student');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Realtime Database Example'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _datacontroller,
              decoration: InputDecoration(labelText: 'Enter some data'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                String text = _datacontroller.text;

                // Write data to Realtime Database
                await _databaseRef.child('student').push().set({
                  'text': text,
                  'timestamp': DateTime.now().millisecondsSinceEpoch,
                });

                _datacontroller.clear();
              },
              child: Text('Save to Realtime Database'),
            ),
          ],
        ),
      ),
    );
  }
}
