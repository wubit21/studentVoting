import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';



void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Rep Votter',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: ClassRepVotterLogin(),
    );
  }
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Login'),
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
                            backgroundColor: Colors.purple[100], // Button color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            padding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 20.0),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              String id = _idController.text;
                              String password = _passwordController.text;

                              try {
                                QuerySnapshot querySnapshot =
                                    await FirebaseFirestore.instance
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
                                      Fluttertoast.showToast(
                                        msg: 'Login successful',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                      // Navigator.pushReplacement(
                                      //   context,
                                      //   MaterialPageRoute(
                                      //       builder: (context) =>
                                      //           EnterIDPage()),
                                      // );
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: 'Incorrect ID or password',
                                        toastLength: Toast.LENGTH_LONG,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  }
                                } else {
                                  Fluttertoast.showToast(
                                    msg: 'Incorrect ID or password',
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
                          child: const Text('Login'),
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
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
