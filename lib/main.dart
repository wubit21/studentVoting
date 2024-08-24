import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';

import 'package:finalproj/screens/auth/classVotterRegister.dart';
import 'package:finalproj/screens/auth/staffSignupPage.dart';
import 'package:finalproj/screens/registrar/checkid.dart';
import 'package:finalproj/screens/ssa/PrVpS.dart';
import 'package:finalproj/screens/ssa/addPresidentCandidate.dart';
import 'package:finalproj/screens/ssa/classRepElec.dart';
import 'package:finalproj/screens/ssa/presidentElection.dart';
import 'package:finalproj/screens/ssa/ssdPage.dart';
import 'package:finalproj/screens/votting/idEntrance.dart';
import 'package:finalproj/screens/votting/presidentVotePoll.dart';
import 'package:flutter/material.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class ClassRepVotterLogin extends StatefulWidget {
  @override
  _ClassRepVotterLoginState createState() => _ClassRepVotterLoginState();
}

class _ClassRepVotterLoginState extends State<ClassRepVotterLogin> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 400,
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
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _idController,
                decoration: InputDecoration(labelText: 'ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your ID';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple[100],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    String id = _idController.text;
                    String password = _passwordController.text;

                    try {
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('classRepVotter')
                          .where('id', isEqualTo: id)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var userData = querySnapshot.docs.first.data()
                            as Map<String, dynamic>;
                        String? storedPassword =
                            userData['password'] as String?;
                        if (storedPassword != null) {
                          var bytes = utf8.encode(password);
                          var digest = sha256.convert(bytes);
                          String hashedPassword = digest.toString();

                          if (storedPassword == hashedPassword) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EnterIDPage()),
                            );
                          } else {
                            _showAlertDialog(
                                context, 'Error', 'Incorrect ID or password');
                          }
                        }
                      } else {
                        _showAlertDialog(
                            context, 'Error', 'Incorrect ID or password');
                      }
                    } catch (e) {
                      print('Error signing in: $e');
                      _showAlertDialog(context, 'Error',
                          'An error occurred while signing in. Please try again.');
                    }
                  }
                },
                child: const Text('Login as a voter'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Debre Markos University Voting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: WelcomePage(),
    );
  }
}

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100], // Light purple color
        title: Text(
          'Debre Markos University Voting',
          style:
              TextStyle(color: Colors.black), // Black text color for contrast
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to the login page when signin button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: const Text('Staff Member'), // Text for the signin button
            ),
          ),
          ////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to Add Class Representative Candidates page
//  Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => StudentServiceAdministrator()),
//     ElectedStudents            );




                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdateDisciplineScreen()),
                );
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ClassRepresentativeElectionScreen()),
                // );
              },
              child: Text('Test'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.purple[100],
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ),
          /////
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to students page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClassRepVotterReg()),
                );
              },
              child: Text('Students'),
              style: ElevatedButton.styleFrom(),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/votee.png', // Replace with your logo asset path
                  height: 200,
                ),
                SizedBox(height: 20),
                Text(
                  'Welcome to Debre Markos University Students\' Union Voting!',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 34, 34, 34),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  'Participate in shaping the future of our university by casting your vote.',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ClassRepVotterLogin(), // Insert the login box here
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                '© 2024 Debre Markos University',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}