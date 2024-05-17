import 'package:flutter/material.dart';

void main() {
  runApp(ssaDashboard());
}

class ssaDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Welcome to Student Service Directorate Dashboard Page'),
        ),
        body: Center(
          child: Text(
            'Welcome',
            style: TextStyle(fontSize: 32.0),
          ),
        ),
      ),
    );
  }
}
