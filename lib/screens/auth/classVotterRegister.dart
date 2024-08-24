import 'dart:convert';
import 'package:crypto/crypto.dart';
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
      home: ClassRepVotterReg(),
    );
  }
}

class ClassRepVotterReg extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> checkAndAddData(
      BuildContext context, String id, String password) async {
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
        // Check if the ID is already registered in the 'classRepVotter' collection
        DocumentSnapshot classRepDoc = await _firestore
            .collection('classRepVotter')
            .doc(id.replaceAll('/', '_'))
            .get();

        if (classRepDoc.exists) {
          // Show alert dialog if the student has already registered
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Already Registered'),
                content: Text('Student ID has already been registered.'),
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

          print('Student ID has already been registered.');
        } else {
          var bytes = utf8.encode(password);
          var digest = sha256.convert(bytes);
          String hashedPassword = digest.toString();
          // Add the ID and password to the 'classRepVotter' collection
          await _firestore.collection('classRepVotter').doc(id.replaceAll('/', '_')).set({
            'id': id, // Store the original ID
            'password': hashedPassword,
          });

          // Log the data added to the collection
          print('Data added to classRepVotter: id=$id, password=$password');

          // Show success alert dialog if the document exists
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Success'),
                content: Text(
                    'Registration Successful'),
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

          print('Registration Successful.');
        }
      } else {
        // Show failure alert dialog if the document does not exist
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error'),
              content: Text(
                  'ID does not exist!'),
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

        print('Student ID does not exist in the studentData collection.');
      }
    } catch (e) {
      print('Error checking and adding data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Registration'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome!',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 3, 3, 3),
                ),
              ),
              SizedBox(height: 24.0),
              Center(
                child: Container(
                  width: 400, // Set a specific width for the container
                  padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.purple[50],
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'Enter Student ID',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => checkAndAddData(
                            context, _idController.text, _passwordController.text),
                        child: Text('Check ID and Register'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100], // Button color
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 20.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:convert';

// import 'package:crypto/crypto.dart';
// import 'package:finalproj/firebase_service.dart';
// import 'package:finalproj/main.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   await FirebaseService.initialize();
//   runApp(MyApp());
// }

// class ClassRepVotterReg extends StatelessWidget {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final TextEditingController _idController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();

//   Future<void> checkAndAddData(
//       BuildContext context, String id, String password) async {
//     try {
//       // Log the ID being checked
//       print('Checking ID: $id');

//       // Query the 'studentData' collection to check if the document with the entered 'id' field exists
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('studentData')
//           .where('id', isEqualTo: id)
//           .get();

//       // Log the result of the query
//       print('Query snapshot: ${querySnapshot.docs}');

//       if (querySnapshot.docs.isNotEmpty) {
//         // Check if the ID is already registered in the 'classRepVotter' collection
//         DocumentSnapshot classRepDoc = await _firestore
//             .collection('classRepVotter')
//             .doc(id.replaceAll('/', '_'))
//             .get();

//         if (classRepDoc.exists) {
//           // Show alert dialog if the student has already registered
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Already Registered'),
//                 content: Text('Student ID has already been registered.'),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text('OK'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );

//           print('Student ID has already been registered.');
//         } else {
//           var bytes = utf8.encode(password);
//           var digest = sha256.convert(bytes);
//           String hashedPassword = digest.toString();
//           // Add the ID and password to the 'classRepVotter' collection
//           await _firestore.collection('classRepVotter').doc(id.replaceAll('/', '_')).set({
//             'id': id, // Store the original ID
//             'password': hashedPassword,
//           });

//           // Log the data added to the collection
//           print('Data added to classRepVotter: id=$id, password=$password');

//           // Show success alert dialog if the document exists
//           showDialog(
//             context: context,
//             builder: (BuildContext context) {
//               return AlertDialog(
//                 title: Text('Success'),
//                 content: Text(
//                     'Student ID exists and has been added to classRepVotter.'),
//                 actions: <Widget>[
//                   TextButton(
//                     child: Text('OK'),
//                     onPressed: () {
//                       Navigator.of(context).pop();
//                     },
//                   ),
//                 ],
//               );
//             },
//           );

//           print('Student ID exists and has been added to classRepVotter.');
//         }
//       } else {
//         // Show failure alert dialog if the document does not exist
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('Error'),
//               content: Text(
//                   'Student ID does not exist in the studentData collection.'),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('OK'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                 ),
//               ],
//             );
//           },
//         );

//         print('Student ID does not exist in the studentData collection.');
//       }
//     } catch (e) {
//       print('Error checking and adding data: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Student ID'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: TextField(
//                 controller: _idController,
//                 decoration: InputDecoration(
//                   labelText: 'Enter Student ID',
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             TextFormField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your password';
//                 }
//                 if (value.length < 8) {
//                   return 'Password must be at least 8 characters long';
//                 }
//                 return null;
//               },
//             ),
//             ElevatedButton(
//               onPressed: () => checkAndAddData(
//                   context, _idController.text, _passwordController.text),
//               child: Text('Check ID and Register'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }







// import 'package:finalproj/screens/votting/classVotePoll.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:finalproj/firebase_service.dart';
// void main() async {
//   await FirebaseService.initialize();
//   runApp(MyApp());
// }


// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ClassRepVotterReg(),
//     );
//   }
// }

// class ClassRepVotterReg extends StatefulWidget {
//   @override
//   _ClassRepVotterRegState createState() => _ClassRepVotterRegState();
// }

// class _ClassRepVotterRegState extends State<ClassRepVotterReg> {
//   final TextEditingController _idController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> checkStudentId(String id) async {
//     try {
//       print('Checking student ID: $id'); // Debugging line
//       final snapshot = await _firestore.collection('studentData').doc(id).get();
//       print('Snapshot data: ${snapshot.data()}'); // Debugging line

//       if (snapshot.exists) {
//         _showAlertDialog(
//             'ID Exists', 'The student ID $id exists in the database.');
//       } else {
//         _showAlertDialog('ID Not Found',
//             'The student ID $id does not exist in the database.');
//       }
//     } catch (e) {
//       print('Error checking student ID: $e'); // Debugging line
//       _showAlertDialog(
//           'Error', 'An error occurred while checking the student ID.');
//     }
//   }

//   void _showAlertDialog(String title, String content) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Student ID'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _idController,
//               decoration: InputDecoration(labelText: 'Enter Student ID'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final id = _idController.text.trim();
//                 if (id.isNotEmpty) {
//                   checkStudentId(id);
//                 } else {
//                   _showAlertDialog('Input Error', 'Please enter a student ID.');
//                 }
//               },
//               child: Text('Check ID'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'package:finalproj/screens/votting/classVotePoll.dart';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() async {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: ClassRepVotterReg(),
//     );
//   }
// }

// class ClassRepVotterReg extends StatefulWidget {
//   @override
//   _ClassRepVotterRegState createState() => _ClassRepVotterRegState();
// }

// class _ClassRepVotterRegState extends State<ClassRepVotterReg> {
//   final TextEditingController _idController = TextEditingController();
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<void> checkStudentId(String id) async {
//     try {
//       print('Checking student ID: $id'); // Debugging line
//       final snapshot = await _firestore.collection('studentData').doc(id).get();
//       print('Snapshot data: ${snapshot.data()}'); // Debugging line

//       if (snapshot.exists) {
//         _showAlertDialog(
//             'ID Exists', 'The student ID $id exists in the database.');
//       } else {
//         _showAlertDialog('ID Not Found',
//             'The student ID $id does not exist in the database.');
//       }
//     } catch (e) {
//       print('Error checking student ID: $e'); // Debugging line
//       _showAlertDialog(
//           'Error', 'An error occurred while checking the student ID.');
//     }
//   }

//   void _showAlertDialog(String title, String content) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(title),
//           content: Text(content),
//           actions: [
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Check Student ID'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _idController,
//               decoration: InputDecoration(labelText: 'Enter Student ID'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 final id = _idController.text.trim();
//                 if (id.isNotEmpty) {
//                   checkStudentId(id);
//                 } else {
//                   _showAlertDialog('Input Error', 'Please enter a student ID.');
//                 }
//               },
//               child: Text('Check ID'),
//             ),
            
//           ],
//         ),
//       ),
//     );
//   }
// }

// SizedBox(height: 10),
            // ElevatedButton(
            //   onPressed: () {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => VotingApp()),
            //       );
            //     },
            //   child: Text('Vote'),
            // ),

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ClassRepVoterReg extends StatefulWidget {
//   @override
//   _ClassRepVoterRegState createState() => _ClassRepVoterRegState();
// }

// class _ClassRepVoterRegState extends State<ClassRepVoterReg> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _otpController = TextEditingController();
//   String _verificationId = '';

//   Future<void> _sendOTP() async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: _phoneController.text,
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         await _auth.signInWithCredential(credential);
//         _showAlert('Phone number automatically verified and user signed in.');
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         _showAlert('Phone number verification failed. Code: ${e.code}. Message: ${e.message}');
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//         _showAlert('Please check your phone for the verification code.');
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         setState(() {
//           _verificationId = verificationId;
//         });
//       },
//     );
//   }

//   Future<void> _verifyOTP() async {
//     PhoneAuthCredential credential = PhoneAuthProvider.credential(
//       verificationId: _verificationId,
//       smsCode: _otpController.text,
//     );

//     await _auth.signInWithCredential(credential);
//     _showAlert('Phone number verified and user signed in.');
//   }

//   void _showAlert(String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Alert'),
//           content: Text(message),
//           actions: <Widget>[
//             TextButton(
//               child: Text('OK'),
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OTP Verification'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             TextField(
//               controller: _phoneController,
//               decoration: InputDecoration(
//                 labelText: 'Phone Number',
//               ),
//               keyboardType: TextInputType.phone,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _sendOTP,
//               child: Text('Send OTP'),
//             ),
//             TextField(
//               controller: _otpController,
//               decoration: InputDecoration(
//                 labelText: 'Enter OTP',
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             SizedBox(height: 16),
//             ElevatedButton(
//               onPressed: _verifyOTP,
//               child: Text('Verify OTP'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
