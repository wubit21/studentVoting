import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssessmentAdd extends StatefulWidget {
  @override
  _AssessmentAddState createState() => _AssessmentAddState();
}

class _AssessmentAddState extends State<AssessmentAdd> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _examController = TextEditingController();
  final TextEditingController _interviewController = TextEditingController();
  final TextEditingController _presentationController = TextEditingController();
  String _certificateValue = 'Has not been certified';

  Future<void> checkAndAddData(BuildContext context, String id, String name) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('presidentCandidate')
          .where('id', isEqualTo: id)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('ID Exists'),
              content: Text('The entered student ID has already been added.'),
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
        return;
      }

      int exam = int.tryParse(_examController.text) ?? -1;
      if (exam < 0 || exam > 50) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Exam Score'),
              content: Text('Exam score must be a number between 0 and 50.'),
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
        return;
      }

      int interview = int.tryParse(_interviewController.text) ?? -1;
      if (interview < 0 || interview > 15) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Interview Score'),
              content: Text('Interview score must be a number between 0 and 15.'),
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
        return;
      }

      int presentation = int.tryParse(_presentationController.text) ?? -1;
      if (presentation < 0 || presentation > 15) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Invalid Presentation Score'),
              content: Text('Presentation score must be a number between 0 and 15.'),
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
        return;
      }

      bool shouldAdd = await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Confirm'),
                content: Text('Do you want to add this student to the president Candidates?'),
                actions: <Widget>[
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                  TextButton(
                    child: Text('Add'),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                  ),
                ],
              );
            },
          ) ??
          false;

      if (shouldAdd) {
        await _firestore.collection('presidentCandidate').add({
          'id': id,
          'name': name,
          'department': '',
          'exam': exam,
          'certificate': _certificateValue == 'Has been certified',
          'interview': interview,
          'presentation': presentation,
          'vote': 0,
          'position': null,
        });

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Success'),
              content: Text('Student assessment added successfully.'),
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
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred: $e'),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Class Rep Voter Registration'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Container(
          width: 400,
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
                'Add New Assessment',
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
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _examController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Exam',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: _certificateValue,
                decoration: InputDecoration(
                  labelText: 'Certificate',
                  border: OutlineInputBorder(),
                ),
                items: [
                  DropdownMenuItem(
                    value: 'Has been certified',
                    child: Text('Has been certified'),
                  ),
                  DropdownMenuItem(
                    value: 'Has not been certified',
                    child: Text('Has not been certified'),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    _certificateValue = value!;
                  });
                },
              ),
              SizedBox(height: 20),
              TextField(
                controller: _interviewController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Interview',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _presentationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Presentation',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  String id = _idController.text;
                  String name = _nameController.text;
                  checkAndAddData(context, id, name);
                },
                child: Text('Add assessment'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
