import 'package:finalproj/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../main.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class UpdateDisciplineScreen extends StatefulWidget {
  @override
  _UpdateDisciplineScreenState createState() => _UpdateDisciplineScreenState();
}

class _UpdateDisciplineScreenState extends State<UpdateDisciplineScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();
  String _selectedDisciplineStatus = 'has no discipline issue'; // default value

  Future<void> updateDiscipline(BuildContext context, String id) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('studentData')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference documentReference =
            querySnapshot.docs.first.reference;
        bool disciplineStatus =
            _selectedDisciplineStatus == 'has discipline issue';
        await documentReference.update({'discipline': disciplineStatus});

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Discipline status updated successfully.'),
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
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Student Discipline Status'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Container(
          width: 300, // Reduced width for the box
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.purple[50],
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Update Discipline Status',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[100],
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _idController,
                decoration: InputDecoration(
                  labelText: 'Student ID',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _selectedDisciplineStatus,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: <String>[
                  'has no discipline issue',
                  'has discipline issue'
                ].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedDisciplineStatus = newValue!;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String id = _idController.text;
                  updateDiscipline(context, id);
                },
                child: Text('Update Discipline'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100], // Background color
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
