import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/main.dart';
import 'package:finalproj/screens/registrarDashboard.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:finalproj/firebase_service.dart';
import 'package:flutter/services.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class AddStudentForm extends StatefulWidget {
  @override
  _AddStudentFormState createState() => _AddStudentFormState();
}

class _AddStudentFormState extends State<AddStudentForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  String? _department;
  String? _gender;
  String? _section;
  String? _academicYear;
  String? _college;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Student'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                      return 'last name cannot contain numbers';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Gender'),
                  items: ['Male', 'Female']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _gender = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select gender';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _idController,
                  decoration: InputDecoration(
                    labelText: 'ID Type',
                    hintText: 'Format: AAA/0000/00',
                  ),
                  inputFormatters: [
                    TextInputFormatter.withFunction((oldValue, newValue) {
                      // Convert the input to uppercase for the first three characters
                      if (newValue.text.length <= 3) {
                        return newValue.copyWith(
                          text: newValue.text.toUpperCase(),
                          selection: newValue.selection,
                        );
                      }
                      return newValue;
                    }),
                  ],
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter ID type';
                    }
                    if (!RegExp(r'^[A-Z]{3}/\d{4}/\d{2}$').hasMatch(value)) {
                      return 'Invalid ID format. Please enter in the format: AAA/0000/00';
                    }
                    return null;
                  },
                ),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //   setState(() {
                  //     _email = value;
                  //   });
                  // },
                ),
                // Department
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'College'),
                  items: [
                    'College of Business & Economics',
                    'College of Health Science',
                    'College of Natural and Computational Sciences',
                    'College of Agriculture & Natural Resource',
                    'College of Social Sciences & Humanities',
                    'College of Technology Departments',
                    'School of Medicine',
                    'Law School',
                    'Institute of Education & Behavioral Science',
                    'Land Administration'
                  ]
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _college = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a college';
                    }
                    return null;
                  },
                ),
                if (_college == 'College of Business & Economics')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Accounting and Finance'),
                        leading: Radio<String>(
                          value: 'Accounting and Finance',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Banking and Finance'),
                        leading: Radio<String>(
                          value: 'Banking and Finance',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Economics'),
                        leading: Radio<String>(
                          value: 'Economics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Management'),
                        leading: Radio<String>(
                          value: 'Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college == 'College of Health Science')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Medical Laboratory'),
                        leading: Radio<String>(
                          value: 'Medical Laboratory',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Midwifery'),
                        leading: Radio<String>(
                          value: 'Midwifery',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Nursing'),
                        leading: Radio<String>(
                          value: 'Nursing',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Pharmacy'),
                        leading: Radio<String>(
                          value: 'Pharmacy',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Public Health Office'),
                        leading: Radio<String>(
                          value: 'Public Health Office',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                if (_college == 'College of Natural and Computational Sciences')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Bio-Technology'),
                        leading: Radio<String>(
                          value: 'Bio-Technology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Biology'),
                        leading: Radio<String>(
                          value: 'Biology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Chemistry'),
                        leading: Radio<String>(
                          value: 'Chemistry',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Mathematics'),
                        leading: Radio<String>(
                          value: 'Mathematics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Physics'),
                        leading: Radio<String>(
                          value: 'Physics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Sport Science'),
                        leading: Radio<String>(
                          value: 'Sport Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Statistics'),
                        leading: Radio<String>(
                          value: 'Statistics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college ==
                    'College of Agriculture & Natural Resource')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Agri-Business and Value Chain'),
                        leading: Radio<String>(
                          value: 'Agri-Business and Value Chain',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Management'),
                        leading: Radio<String>(
                          value: 'Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Agro Economics'),
                        leading: Radio<String>(
                          value: 'Agro Economics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Agro-Forestry'),
                        leading: Radio<String>(
                          value: 'Agro-Forestry',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Animal Science'),
                        leading: Radio<String>(
                          value: 'Animal Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Horticulture'),
                        leading: Radio<String>(
                          value: 'Horticulture',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Natural Resource Management'),
                        leading: Radio<String>(
                          value: 'Natural Resource Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Plant Science'),
                        leading: Radio<String>(
                          value: 'Plant Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Rural Development'),
                        leading: Radio<String>(
                          value: 'Rural Development',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college == 'College of Technology Departments')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Civil Engineering'),
                        leading: Radio<String>(
                          value: 'Civil Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Computer Science'),
                        leading: Radio<String>(
                          value: 'Computer Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Construction Technology'),
                        leading: Radio<String>(
                          value: 'Construction Technology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Management Engineering'),
                        leading: Radio<String>(
                          value: 'Management Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title:
                            const Text('Electrical and Computer Engineering'),
                        leading: Radio<String>(
                          value: 'Electrical and Computer Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text(
                            'Hydraulics and Environmental Engineering'),
                        leading: Radio<String>(
                          value: 'Hydraulics and Environmental Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Information Technology'),
                        leading: Radio<String>(
                          value: 'Information Technology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Mechanical Engineering'),
                        leading: Radio<String>(
                          value: 'Mechanical Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Software Engineering'),
                        leading: Radio<String>(
                          value: 'Software Engineering',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college == 'College of Social Sciences & Humanities')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Civics and Ethical Education'),
                        leading: Radio<String>(
                          value: 'Civics and Ethical Education',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('English Language and Literature'),
                        leading: Radio<String>(
                          value: 'English Language and Literature',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Ethiopian Language and Literature'),
                        leading: Radio<String>(
                          value: 'Ethiopian Language and Literature',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Amharic'),
                        leading: Radio<String>(
                          value: 'Amharic',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title:
                            const Text('Geography and Environmental Studies'),
                        leading: Radio<String>(
                          value: 'Geography and Environmental Studies',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('History and Heritage Management'),
                        leading: Radio<String>(
                          value: 'History and Heritage Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Sociology'),
                        leading: Radio<String>(
                          value: 'Sociology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )

//department end
                else if (_college ==
                    'College of Agriculture & Natural Resource')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Agri-Business and Value Chain'),
                        leading: Radio<String>(
                          value: 'Agri-Business and Value Chain',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Management'),
                        leading: Radio<String>(
                          value: 'Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Agro Economics'),
                        leading: Radio<String>(
                          value: 'Agro Economics',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Agro-Forestry'),
                        leading: Radio<String>(
                          value: 'Agro-Forestry',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Animal Science'),
                        leading: Radio<String>(
                          value: 'Animal Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Horticulture'),
                        leading: Radio<String>(
                          value: 'Horticulture',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Natural Resource Management'),
                        leading: Radio<String>(
                          value: 'Natural Resource Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Plant Science'),
                        leading: Radio<String>(
                          value: 'Plant Science',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Rural Development'),
                        leading: Radio<String>(
                          value: 'Rural Development',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college ==
                    'Institute of Education & Behavioral Science')
                  Column(
                    children: [
                      ListTile(
                        title:
                            const Text('Educational Planning and Management'),
                        leading: Radio<String>(
                          value: 'Educational Planning and Management',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                      ListTile(
                        title: const Text('Psychology'),
                        leading: Radio<String>(
                          value: 'Psychology',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college == 'Institute of Land Administration')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Land Administration'),
                        leading: Radio<String>(
                          value: 'Land Administration',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  )
                else if (_college == 'Law School')
                  Column(
                    children: [
                      ListTile(
                        title: const Text('Law School'),
                        leading: Radio<String>(
                          value: 'Law School',
                          groupValue: _department,
                          onChanged: (String? value) {
                            setState(() {
                              _department = value!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),

//wubitdepart
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Section'),
                  items: ['A', 'B', 'C', 'D']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _section = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select section';
                    }
                    return null;
                  },
                ),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Academic Year'),
                  items: ['I', 'II', 'III', 'IV', 'V']
                      .map((label) => DropdownMenuItem(
                            child: Text(label),
                            value: label,
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _academicYear = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select academic year';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _phoneNumberController,
                  decoration: InputDecoration(labelText: 'Phone Number'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter phone number';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                  // onChanged: (value) {
                  //   setState(() {
                  //     _phoneNumber = int.tryParse(value) ?? 0;
                  //   });
                  // },
                ),
                TextFormField(
                  controller: _gpaController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(labelText: 'GPA'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      _showErrorMessage(context, 'Please enter GPA');
                      return 'Please enter GPA';
                    }
                    final gpa = double.tryParse(value);
                    if (gpa == null) {
                      _showErrorMessage(context, 'Please enter a valid GPA');
                      return 'Please enter a valid GPA';
                    }
                    if (gpa < 0) {
                      _showErrorMessage(context, 'GPA cannot be negative');
                      return 'GPA cannot be negative';
                    }
                    if (gpa > 4) {
                      _showErrorMessage(
                          context, 'GPA cannot be greater than 4');
                      return 'GPA cannot be greater than 4';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        // Form is valid, process data
                        CollectionReference usersCollection = FirebaseFirestore
                            .instance
                            .collection('studentData');
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;
                        String id = _idController.text;
                        String gpa = _gpaController.text;
                        String email = _emailController.text;
                        String phoneNumber = _phoneNumberController.text;
                        String? section = _section;

                        String? gender = _gender;
                        String? academicYear = _academicYear;
                        String? department = _department;
                        // Set approved to false by default

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

                        // Check if the id is already registered
                        QuerySnapshot idSnapshot = await usersCollection
                            .where('id', isEqualTo: id)
                            .get();
                        if (idSnapshot.docs.isNotEmpty) {
                          // ID already exists
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'This ID is already registered. Please make sure to enter the correct ID.'),
                          ));
                          return;
                        }

                        try {
                          await usersCollection.add({
                            'firstName': firstName,
                            'lastName': lastName,
                            'email': email,
                            'id': id, // Store hashed password
                            'gender': gender,
                            'department': department,
                            'section': section,
                            'academicYear': academicYear,
                            'phoneNumber': phoneNumber,
                            'gpa': gpa,
                            // Add the 'approved' field
                          });
                          // Data added successfully
                          if (kDebugMode) {
                            print('student data added to Firestore');
                          }

                          // After sign up, navigate to the login page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => registrarDashboard()),
                          );
                        } catch (e) {
                          // Error occurred while adding data
                          if (kDebugMode) {
                            print('Error adding student data: $e');
                          }
                        }

                        // You can add your logic to save or send the data here
                      }
                    },
                    child: Text('Add Student')),
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
    _phoneNumberController.dispose();
    _idController.dispose();
    _gpaController.dispose();
    super.dispose();
  }

  void _showErrorMessage(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
