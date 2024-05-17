// Add a new field 'approved' to the Firestore document structure
// Modify the data added to Firestore to include the 'approved' field
// Set 'approved' to false by default
// Add logic to allow the system admin to update 'approved' to true in the Firebase console

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/screens/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'firebase_service.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SignUpScreen(),
    );
  }
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
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
                    // You can add more password strength checks here
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, process data
                      CollectionReference usersCollection =
                          FirebaseFirestore.instance.collection('staffMember');
                      String firstName = _firstNameController.text;
                      String lastName = _lastNameController.text;
                      String? role = _selectedRole;
                      String email = _emailController.text;
                      String password = _passwordController.text;

                      // Set approved to false by default
                      bool approved = false;

                      // Check if the email is already registered
                      QuerySnapshot emailSnapshot = await usersCollection
                          .where('email', isEqualTo: email)
                          .get();
                      if (emailSnapshot.docs.isNotEmpty) {
                        // Email already exists
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              'This email is already registered. Please use a different one.'),
                        ));
                        return;
                      }

                      // Hash the password using SHA-256
                      var bytes = utf8.encode(password);
                      var digest = sha256.convert(bytes);
                      String hashedPassword = digest.toString();

                      // Add user data to Firestore with 'approved' set to false
                      try {
                        await usersCollection.add({
                          'firstName': firstName,
                          'lastName': lastName,
                          'role': role,
                          'email': email,
                          'password': hashedPassword, // Store hashed password
                          'approved': approved, // Add the 'approved' field
                        });
                        // Data added successfully
                        if (kDebugMode) {
                          print('User data added to Firestore');
                        }

                        // After sign up, navigate to the login page
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      } catch (e) {
                        // Error occurred while adding data
                        if (kDebugMode) {
                          print('Error adding user data: $e');
                        }
                      }

                      // You can add your logic to save or send the data here
                    }
                  },
                  child: const Text('Signup'),
                ),

                SizedBox(height: 8.0), // Add some space between the buttons
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the login page when signin button is pressed
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                    );
                  },
                  child: const Text('Signin'), // Text for the signin button
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
