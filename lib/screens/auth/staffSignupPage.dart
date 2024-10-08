import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';
import 'package:finalproj/main.dart';
import 'package:finalproj/screens/auth/staffLoginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _selectedRole;

  final List<String> _roles = ['Student Service Directorate', 'Registrar'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[100],
        title: Text(
          'Debre Markos University Voting',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text(
                  'Staff Member Sign Up',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Center(
                  child: Container(
                    width: 400, // Set a specific width for the container
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            controller: _firstNameController,
                            decoration: InputDecoration(labelText: 'First Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your first name';
                              }
                              if (value.contains(RegExp(r'[0-9]'))) {
                                return 'First name cannot contain numbers';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _lastNameController,
                            decoration: InputDecoration(labelText: 'Last Name'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your last name';
                              }
                              if (value.contains(RegExp(r'[0-9]'))) {
                                return 'Last name cannot contain numbers';
                              }
                              return null;
                            },
                          ),
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            onChanged: (String? value) {
                              setState(() {
                                _selectedRole = value!;
                              });
                            },
                            items: _roles.map((String role) {
                              return DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              );
                            }).toList(),
                            decoration: InputDecoration(labelText: 'Role'),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select your role';
                              }
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(labelText: 'Email'),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!RegExp(
                                      r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')
                                  .hasMatch(value)) {
                                return 'Please enter a valid email address';
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
                              if (value.length < 8) {
                                return 'Password must be at least 8 characters long';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          Center(
                            child: Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      CollectionReference usersCollection =
                                          FirebaseFirestore.instance
                                              .collection('staffMember');
                                      String firstName =
                                          _firstNameController.text;
                                      String lastName = _lastNameController.text;
                                      String? role = _selectedRole;
                                      String email = _emailController.text;
                                      String password = _passwordController.text;

                                      bool approved = false;

                                      try {
                                        QuerySnapshot emailSnapshot =
                                            await usersCollection
                                                .where('email', isEqualTo: email)
                                                .get();
                                        if (emailSnapshot.docs.isNotEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: Text(
                                                'This email is already registered. Please use a different one.'),
                                          ));
                                          return;
                                        }

                                        var bytes = utf8.encode(password);
                                        var digest = sha256.convert(bytes);
                                        String hashedPassword = digest.toString();

                                        await usersCollection.add({
                                          'firstName': firstName,
                                          'lastName': lastName,
                                          'role': role,
                                          'email': email,
                                          'password': hashedPassword,
                                          'approved': approved,
                                        });
                                        if (kDebugMode) {
                                          print('User data added to Firestore');
                                        }

                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => LoginPage()),
                                        );
                                      } catch (e) {
                                        print('Error adding user data: $e');
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'An error occurred while signing up. Please try again.'),
                                        ));
                                      }
                                    }
                                  },
                                  child: const Text('Sign up'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.purple[100], // Button color
                                  ),
                                ),
                                SizedBox(height: 8.0),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginPage()),
                                    );
                                  },
                                  child: const Text('Sign in'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.purple[100], // Button color
                                  ),
                                ),
                              ],
                            ),
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
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
