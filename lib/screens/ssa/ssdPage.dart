// import 'package:flutter/material.dart';
// import 'package:finalproj/main.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Student Service Administrator',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: StudentServiceAdministrator(),
//     );
//   }
// }


// class StudentServiceAdministrator extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Student Service Administrator'),
//         backgroundColor: Colors.purple[100],
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   Column(
//                     children: [
//                       Image.asset(
//                   'assets/student.png', // Replace with your logo asset path
//                  width: 250,
//                   height: 250,
//                 ),
//                       // Image.network(
//                       //   'https://via.placeholder.com/150', // Replace with your image URL
//                       //   width: 150,
//                       //   height: 150,
//                       // ),
//                       SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Add your button action here
//                         },
//                         child: Text(
//                           'Manage Class Representative Election',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(150, 50),
//                           backgroundColor: Colors.purple[100],
//                         ),
//                       ),
//                     ],
//                   ),
//                   Column(
//                     children: [
//                       Image.asset(
//                   'assets/president.png', // Replace with your logo asset path
//                    width: 250,
//                   height: 250,
//                 ),
//                       // Image.network(
//                       //   'https://via.placeholder.com/150', // Replace with your image URL
//                       //   width: 250,
//                       //   height: 150,
//                       // ),
//                       SizedBox(height: 8),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Add your button action here
//                         },
//                         child: Text(
//                           'Manage President Election',
//                           style: TextStyle(fontSize: 20),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: Size(150, 50),
//                           backgroundColor: Colors.purple[100],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
