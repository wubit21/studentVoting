
import 'package:finalproj/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class HomeScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchAndAddData(BuildContext context) async {
    try {
      // Fetch documents from 'studentData' collection with GPA greater than 2.75
      QuerySnapshot querySnapshot = await _firestore
          .collection('studentData')
          .where('gpa', isGreaterThan: '2.75')
          .where('discipline', isEqualTo: false)
          .get();

      // Iterate over each document
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

        // Add a new field 'vote' with value 0
        data['vote'] = 0;

        // Add the document to 'candidate' collection
        await _firestore.collection('candidate').doc(doc.id).set(data);
      }

      // Show success alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Students for class representatives candidates are casted successfully.'),
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

      print('Data successfully copied from studentData to candidate.');
    } catch (e) {
      print('Error fetching and adding data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Class Representative Candidates'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => fetchAndAddData(context),
          child: Text('Fetch and Add Data'),
        ),
      ),
    );
  }
}
