import 'package:finalproj/main.dart';
import 'package:finalproj/screens/ssa/PrVpS.dart';
import 'package:finalproj/screens/ssa/addClassCandidate.dart';
import 'package:finalproj/screens/ssa/addStudentUnionCollection.dart';
import 'package:finalproj/screens/ssa/addPresidentCandidate.dart';
import 'package:finalproj/screens/ssa/classRepElec.dart';
import 'package:finalproj/screens/ssa/deciplineUpdate.dart';
import 'package:finalproj/screens/ssa/presidentElection.dart';
import 'package:flutter/material.dart';

class StudentServiceAdministrator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Service Administrator'),
        backgroundColor: Colors.purple[100],
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              width: 100, // Set the width of the button
              height: 50, // Set the height of the button
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
                    color: Colors.black, // Change the color to match your theme
                    fontSize: 18.0, // Increase the font size
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/student.png', // Replace with your logo asset path
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ClassRepresentativeElectionScreen()),
                          );
                        },
                        child: Text(
                          'Manage Class Representative Election',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50),
                          backgroundColor: Colors.purple[100],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/president.png', // Replace with your logo asset path
                        width: 250,
                        height: 250,
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Presidentelection()),
                          );
                        },
                        child: Text(
                          'Manage President Election',
                          style: TextStyle(fontSize: 20),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(150, 50),
                          backgroundColor: Colors.purple[100],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// class StudentServiceDirectorPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Students Service Directorate'),
//         centerTitle: true,
//         backgroundColor: Colors.purple[100],
//         actions: <Widget>[
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AssessmentAdd()),
//                 );
//               },
//               child: Text('Add Assessment'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple[100],
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 16.0),
//             child: Container(
//               width: 100,
//               height: 50,
//               child: TextButton(
//                 onPressed: () {
//                   Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(builder: (context) => MyApp()),
//                   );
//                 },
//                 child: Text(
//                   'Logout',
//                   style: TextStyle(
//                     color: Colors.black,
//                     fontSize: 18.0,
//                   ),
//                 ),
//                 style: TextButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => HomeScreen()),
//                 );
//               },
//               child: Text('Add Class Rep Candidates'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple[100],
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => UpdateDisciplineScreen()),
//                 );
//               },
//               child: Text('Add Student to Blacklist'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple[100],
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => addToStudentUnion()),
//                 );
//               },
//               child: Text('Add Student Union members'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple[100],
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8.0),
//             child: ElevatedButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AssessmentAdd()),
//                 );
//               },
//               child: Text('Assessment Add'),
//               style: ElevatedButton.styleFrom(
//                 foregroundColor: Colors.purple[100],
//                 backgroundColor: Colors.white,
//                 padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                 textStyle: TextStyle(fontSize: 18),
//               ),
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.logout),
//             onPressed: () {
//               Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(builder: (context) => MyApp()),
//               );
//             },
//           ),
//         ],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Welcome to the Students Service Directorate!',
//                 style: TextStyle(
//                   fontSize: 26,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.purple[100],
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 20),
//               Text(
//                 'We are dedicated to providing the best services to support our students\' academic and personal growth.',
//                 style: TextStyle(fontSize: 18),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: 40),
//               Image.asset(
//                 'assets/admin.png', // Replace with your logo asset path
//                 height: 200,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Button action
//                 },
//                 child: Text('Get Started'),
//                 style: ElevatedButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   backgroundColor: Colors.blue,
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                   textStyle: TextStyle(fontSize: 18),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: BottomAppBar(
//         color: Colors.purple[100], // Set the background color of the footer
//         child: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 '© 2024 Debre Markos University',
//                 style: TextStyle(fontSize: 16),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }


//fot president


