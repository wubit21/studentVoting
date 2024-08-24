import 'package:finalproj/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Rep Votter Registration',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: UpdateDisciplineScreen(),
    );
  }
}

class UpdateDisciplineScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();

  Future<void> checkAndAddData(BuildContext context, String id) async {
    try {
      // Log the ID being checked
      print('Checking ID: $id');

      // Query the 'studentData' collection to check if the document with the entered 'id' field exists
      QuerySnapshot querySnapshot = await _firestore
          .collection('studentData')
          .where('id', isEqualTo: id)
          .get();

      // Log the result of the query
      print('Query snapshot: ${querySnapshot.docs}');

      if (querySnapshot.docs.isNotEmpty) {
        // Show alert dialog if the student ID exists in the 'studentData' collection
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ID Found'),
              content: Text('The entered student ID exists in the database.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      } else {
        // Show alert dialog if the student ID does not exist in the 'studentData' collection
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid ID'),
              content: Text('The entered student ID does not exist.'),
              actions: <Widget>[
                TextButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      // Handle error
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Rep Votter Registration'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _idController,
              decoration: InputDecoration(labelText: 'Student ID'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String id = _idController.text;
                checkAndAddData(context, id);
              },
              child: Text('Check ID'),
            ),
          ],
        ),
      ),
    );
  }
}
