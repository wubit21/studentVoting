import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';
import 'package:finalproj/main.dart';
import 'package:finalproj/screens/registrar/registrarDashboard.dart';
import 'package:finalproj/screens/ssa/studentServiceDirectorPage.dart';
import 'package:flutter/material.dart';
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
                    String email = _emailController.text;
                    String password = _passwordController.text;

                    try {
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('staffMember')
                          .where('email', isEqualTo: email)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        var userData = querySnapshot.docs.first.data() as Map<String, dynamic>;
                        String? storedPassword = userData['password'] as String?;
                        if (storedPassword != null) {
                          var bytes = utf8.encode(password);
                          var digest = sha256.convert(bytes);
                          String hashedPassword = digest.toString();

                          if (storedPassword == hashedPassword) {
                            String? userRole = userData['role'] as String?;
                            bool? approved = userData['approved'] as bool?;

                            if (approved == true) {
                              if (userRole != null) {
                                switch (userRole) {
                                  case 'Student Service Directorate':
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => studentServiceDirectorPage(),
                                      ),
                                    );
                                    break;
                                  case 'Registrar':
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => registrarDashboard(),
                                      ),
                                    );
                                    break;
                                  default:
                                    Fluttertoast.showToast(
                                      msg: 'Unknown role',
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                    );
                                    break;
                                }
                              }
                            } else {
                              Fluttertoast.showToast(
                                msg: 'Your account has not been approved yet',
                                toastLength: Toast.LENGTH_LONG,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          } else {
                            Fluttertoast.showToast(
                              msg: 'Incorrect email or password',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.BOTTOM,
                            );
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                          msg: 'Incorrect email or password',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }
                    } catch (e) {
                      print('Error signing in: $e');
                      Fluttertoast.showToast(
                        msg: 'An error occurred while signing in. Please try again.',
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                      );
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