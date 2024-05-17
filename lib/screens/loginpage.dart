import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';
import 'package:finalproj/main.dart';
import 'package:finalproj/screens/ssaDashboard.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/screens/registrarDashboard.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Form is valid, process data
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    try {
                      // Retrieve user document from Firestore
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('staffMember')
                          .where('email', isEqualTo: email)
                          .get();

                      // Check if user with provided email exists
                      if (querySnapshot.docs.isNotEmpty) {
                        // Get the first document (assuming email is unique)
                        var userData = querySnapshot.docs.first.data() as Map<
                            String, dynamic>?; // Cast to Map<String, dynamic>
                        if (userData != null) {
                          // Retrieve hashed password from Firestore
                          String? storedPassword =
                              userData['password'] as String?; // Cast to String
                          if (storedPassword != null) {
                            // Hash the password entered during login
                            var bytes = utf8.encode(password);
                            var digest = sha256.convert(bytes);
                            String hashedPassword = digest.toString();

                            // Compare hashed passwords
                            if (storedPassword == hashedPassword) {
                              // Password matches, retrieve user role and approval status
                              String? userRole = userData['role'] as String?;
                              bool? approved = userData['approved'] as bool?;

                              if (approved == true) {
                                // User is approved, allow login
                                if (userRole != null) {
                                  // Navigate based on user role
                                  switch (userRole) {
                                    case 'Student Service Directorate':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ssaDashboard(),
                                        ),
                                      );
                                      break;
                                    case 'Registrar':
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              registrarDashboard(),
                                        ),
                                      );
                                      break;
                                    // Add cases for other roles if needed
                                    default:
                                      // Handle unknown role
                                      break;
                                  }
                                  return; // Exit function after successful login
                                }
                              } else {
                                // User is not approved, display a message
                                Fluttertoast.showToast(
                                  msg: 'Your account has not been approved yet',
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.BOTTOM,
                                );
                                return; // Exit function after displaying the toast message
                              }
                            }

// If email or password is incorrect, display a generic error message
                            Fluttertoast.showToast(
                              msg: 'Incorrect email or password',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        }
                      }
                    } catch (e) {
                      // Handle any errors
                      print('Error signing in: $e');
                    }
                  }
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
