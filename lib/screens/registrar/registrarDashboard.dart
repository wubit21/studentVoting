import 'package:finalproj/screens/registrar/studentData.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(registrarDashboard());
}

class registrarDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to registrar Page'),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              print("Button pressed!");
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddStudentForm()),
              );
            },
            child: const Text('Go to Signup'),
          ),
        ),
      ),
    );
  }
}
