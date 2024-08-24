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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Staff Members Sign in Page'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome Back!',
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
                  child: Form(
                    key: _formKey,
                    child: Column(
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
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100], // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String email = _emailController.text;
                              String password = _passwordController.text;

                              try {
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
                                        .collection('staffMember')
                                        .where('email', isEqualTo: email)
                                        .get();

                                if (querySnapshot.docs.isNotEmpty) {
                                  var userData = querySnapshot.docs.first
                                      .data() as Map<String, dynamic>;
                                  String? storedPassword =
                                      userData['password'] as String?;
                                  if (storedPassword != null) {
                                    var bytes = utf8.encode(password);
                                    var digest = sha256.convert(bytes);
                                    String hashedPassword = digest.toString();

                                    if (storedPassword == hashedPassword) {
                                      String? userRole =
                                          userData['role'] as String?;
                                      bool? approved =
                                          userData['approved'] as bool?;

                                      if (approved == true) {
                                        if (userRole != null) {
                                          switch (userRole) {
                                            case 'Student Service Directorate':
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      StudentServiceAdministrator(),
                                                ),
                                              );
                                              break;
                                            case 'Registrar':
                                              Navigator.pushReplacement(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      RegistrarPage(),
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
                                          msg:
                                              'Your account has not been approved yet',
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
                                  msg:
                                      'An error occurred while signing in. Please try again.',
                                  toastLength: Toast.LENGTH_LONG,
                                  gravity: ToastGravity.BOTTOM,
                                );
                              }
                            }
                          },
                          child: const Text('Sign in'),
                        ),
                      ],
                    ),
                  ),
                ),
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