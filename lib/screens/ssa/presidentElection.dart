import 'package:finalproj/screens/ssa/PrVpS.dart';
import 'package:finalproj/screens/ssa/addPresidentCandidate.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/main.dart';

void main() {
  runApp(MyApp());
}

class Presidentelection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('President Election'),
        backgroundColor: Colors.purple[100],
        actions: [
          TextButton(
            onPressed: () {
              // Add action for the first button
            },
            child: Text(
              '',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Add action for the second button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentAdd()),
              );
            },
            child: Text(
              'Assesesment Add',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              // Add action for the second button
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectedStudents()),
              );
            },
            child: Text(
              ' View Elected Students',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),

          // TextButton(
          //   onPressed: () {
          //     // Add action for the second button
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(builder: (context) => ElectedStudents()),
          //     );
          //   },
          //   child: Text(
          //     'Elected Students',
          //     style: TextStyle(
          //       color: Colors.black,
          //       fontSize: 18.0,
          //     ),
          //   ),
          // ),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('Class Representatives Election Screen Content'),
      ),
    );
  }
}

class PresidentElectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('President Election'),
        backgroundColor: Colors.purple[100],
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AssessmentAdd()),
              );
            },
            child: Text(
              'Add Assessment',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              // Add action for the second button

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ElectedStudents()),
              );
            },
            child: Text(
              'ElectedStudents',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
              ),
            ),
          ),
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
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: Text('President Election Screen Content'),
      ),
    );
  }
}
