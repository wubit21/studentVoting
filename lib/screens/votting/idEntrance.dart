import 'package:finalproj/main.dart';
import 'package:finalproj/screens/votting/classVotePoll.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class EnterIDPage extends StatefulWidget {
  @override
  _EnterIDPageState createState() => _EnterIDPageState();
}

class _EnterIDPageState extends State<EnterIDPage> {
  final TextEditingController _idController = TextEditingController();
  String? _department;

  Future<void> _fetchDepartment() async {
    String id = _idController.text.trim(); // Trim any leading/trailing whitespace
    if (id.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter an ID')),
      );
      return;
    }

    try {
      QuerySnapshot studentSnapshot = await FirebaseFirestore.instance
          .collection('studentData')
          .where('id', isEqualTo: id)
          .get();

      if (studentSnapshot.docs.isNotEmpty) {
        DocumentSnapshot studentDoc = studentSnapshot.docs.first;
        setState(() {
          _department = studentDoc['department'];
        });

        // Navigate to the next page and pass the department
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ClassVotePoll(department: _department!)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('ID not found')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching department: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter ID'),
        backgroundColor: Colors.purple[100],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 100,
              height: 50,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyApp()),
                  );
                },
                child: Text(
                  'Logout',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18.0,
                  ),
                ),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: 400, // Reduced width for the box
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
                    'Enter Student ID',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 10, 10, 10),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(
                      labelText: 'Student ID',
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _fetchDepartment,
                    child: Text('Submit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[100], // Button color
                    ),
                  ),
                  if (_department != null) ...[
                    SizedBox(height: 20),
                    Text('Department: $_department'),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to students page
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClassVotePoll(department: _department!)),
                          );
                        },
                        child: Text('Students'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100], // Button color
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NextPage extends StatelessWidget {
  final String department;

  const NextPage({Key? key, required this.department}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Candidates'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Text('Department: $department'),
      ),
    );
  }
}
