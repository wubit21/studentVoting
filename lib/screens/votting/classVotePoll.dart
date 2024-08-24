import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(VotingApp());
}

class VotingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Representative Voting',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: DepartmentSelectionScreen(),
    );
  }
}

class DepartmentSelectionScreen extends StatefulWidget {
  @override
  _DepartmentSelectionScreenState createState() => _DepartmentSelectionScreenState();
}

class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
  final TextEditingController _departmentController = TextEditingController();

  void _navigateToPollScreen(String department) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ClassVotePoll(department: department)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Department'),
        backgroundColor: Colors.purple[100],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _departmentController,
              decoration: InputDecoration(
                labelText: 'Enter Department',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String department = _departmentController.text.trim();
                if (department.isNotEmpty) {
                  _navigateToPollScreen(department);
                }
              },
              child: Text('Submit'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[100],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[50],
        child: Container(
          height: 60,
          color: Colors.purple[100],
          child: Center(
            child: Text(
              '© 2024 Debre Markos University',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ),
      ),
    );
  }
}

class ClassVotePoll extends StatefulWidget {
  final String department;

  ClassVotePoll({required this.department});

  @override
  _ClassVotePollState createState() => _ClassVotePollState();
}

class _ClassVotePollState extends State<ClassVotePoll> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId = "user123";  // Example user ID, replace with actual user ID logic

  Map<String, int> maleCandidates = {};
  Map<String, int> femaleCandidates = {};
  bool hasVotedMale = false;
  bool hasVotedFemale = false;

  @override
  void initState() {
    super.initState();
    fetchCandidates();
    checkIfVoted();
  }

  Future<void> fetchCandidates() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('candidate')
          .where('department', isEqualTo: widget.department)
          .get();

      Map<String, int> maleCandidatesData = {};
      Map<String, int> femaleCandidatesData = {};

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        String fullName = '${data['firstName']} ${data['lastName']}';
        int voteCount = data['vote'] ?? 0;

        if (data['gender'] == 'Male') {
          maleCandidatesData[fullName] = voteCount;
        } else if (data['gender'] == 'Female') {
          femaleCandidatesData[fullName] = voteCount;
        }
      }

      setState(() {
        maleCandidates = maleCandidatesData;
        femaleCandidates = femaleCandidatesData;
      });
    } catch (e) {
      print('Error fetching candidates: $e');
    }
  }

  Future<void> checkIfVoted() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('votes').doc(userId).get();
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          hasVotedMale = data['votedMale'] ?? false;
          hasVotedFemale = data['votedFemale'] ?? false;
        });
      }
    } catch (e) {
      print('Error checking vote status: $e');
    }
  }

  void vote(String candidate, bool isMale) async {
    if ((isMale && hasVotedMale) || (!isMale && hasVotedFemale)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already voted for this category')),
      );
      return;
    }

    setState(() {
      if (isMale) {
        maleCandidates[candidate] = (maleCandidates[candidate] ?? 0) + 1;
        hasVotedMale = true;
      } else {
        femaleCandidates[candidate] = (femaleCandidates[candidate] ?? 0) + 1;
        hasVotedFemale = true;
      }
    });

    try {
      String gender = isMale ? 'Male' : 'Female';
      DocumentSnapshot doc = await _firestore.collection('candidate')
          .where('firstName', isEqualTo: candidate.split(' ')[0])
          .where('lastName', isEqualTo: candidate.split(' ')[1])
          .where('gender', isEqualTo: gender)
          .where('department', isEqualTo: widget.department)
          .limit(1)
          .get()
          .then((querySnapshot) => querySnapshot.docs.first);

      await _firestore.collection('candidate').doc(doc.id).update({
        'vote': FieldValue.increment(1),
      });

      await _firestore.collection('votes').doc(userId).set({
        'votedMale': hasVotedMale,
        'votedFemale': hasVotedFemale,
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating vote: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalMaleVotes = maleCandidates.values.isNotEmpty
        ? maleCandidates.values.reduce((a, b) => a + b)
        : 0;
    int totalFemaleVotes = femaleCandidates.values.isNotEmpty
        ? femaleCandidates.values.reduce((a, b) => a + b)
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vote for Candidates - ${widget.department}'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 800,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              borderRadius: BorderRadius.circular(12.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6.0,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  'Vote for Male Candidate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                ...maleCandidates.entries.map((entry) {
                  double percentage = (totalMaleVotes > 0)
                      ? (entry.value / totalMaleVotes) * 100
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key),
                              SizedBox(height: 4),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: entry.value / 100,
                                    child: Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.blue,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('${entry.value} votes'),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => vote(entry.key, true),
                          child: Text('Vote'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 20),
                Text(
                  'Vote for Female Candidate',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                SizedBox(height: 20),
                ...femaleCandidates.entries.map((entry) {
                  double percentage = (totalFemaleVotes > 0)
                      ? (entry.value / totalFemaleVotes) * 100
                      : 0.0;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(entry.key),
                              SizedBox(height: 4),
                              Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  FractionallySizedBox(
                                    widthFactor: entry.value / 100,
                                    child: Container(
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: Colors.pink,
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 4),
                              Text('${entry.value} votes'),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => vote(entry.key, false),
                          child: Text('Vote'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple[100],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// void main() {
//   runApp(VotingApp());
// }

// class VotingApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Class Representative Voting',
//       theme: ThemeData(
//         primarySwatch: Colors.purple,
//       ),
//       home: DepartmentSelectionScreen(),
//     );
//   }
// }

// class DepartmentSelectionScreen extends StatefulWidget {
//   @override
//   _DepartmentSelectionScreenState createState() => _DepartmentSelectionScreenState();
// }

// class _DepartmentSelectionScreenState extends State<DepartmentSelectionScreen> {
//   final TextEditingController _departmentController = TextEditingController();

//   void _navigateToPollScreen(String department) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (context) => ClassVotePoll(department: department)),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Department'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: _departmentController,
//               decoration: InputDecoration(
//                 labelText: 'Enter Department',
//               ),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 String department = _departmentController.text.trim();
//                 if (department.isNotEmpty) {
//                   _navigateToPollScreen(department);
//                 }
//               },
//               child: Text('Submit'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class ClassVotePoll extends StatefulWidget {
//   final String department;

//   ClassVotePoll({required this.department});

//   @override
//   _ClassVotePollState createState() => _ClassVotePollState();
// }

// class _ClassVotePollState extends State<ClassVotePoll> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final String userId = "user123";  // Example user ID, replace with actual user ID logic

//   Map<String, int> maleCandidates = {};
//   Map<String, int> femaleCandidates = {};
//   bool hasVotedMale = false;
//   bool hasVotedFemale = false;

//   @override
//   void initState() {
//     super.initState();
//     fetchCandidates();
//     checkIfVoted();
//   }

//   Future<void> fetchCandidates() async {
//     try {
//       QuerySnapshot querySnapshot = await _firestore
//           .collection('candidate')
//           .where('department', isEqualTo: widget.department)
//           .get();

//       Map<String, int> maleCandidatesData = {};
//       Map<String, int> femaleCandidatesData = {};

//       for (QueryDocumentSnapshot doc in querySnapshot.docs) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         String fullName = '${data['firstName']} ${data['lastName']}';
//         int voteCount = data['vote'] ?? 0;

//         if (data['gender'] == 'Male') {
//           maleCandidatesData[fullName] = voteCount;
//         } else if (data['gender'] == 'Female') {
//           femaleCandidatesData[fullName] = voteCount;
//         }
//       }

//       setState(() {
//         maleCandidates = maleCandidatesData;
//         femaleCandidates = femaleCandidatesData;
//       });
//     } catch (e) {
//       print('Error fetching candidates: $e');
//     }
//   }

//   Future<void> checkIfVoted() async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection('votes').doc(userId).get();
//       if (doc.exists) {
//         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
//         setState(() {
//           hasVotedMale = data['votedMale'] ?? false;
//           hasVotedFemale = data['votedFemale'] ?? false;
//         });
//       }
//     } catch (e) {
//       print('Error checking vote status: $e');
//     }
//   }

//   void vote(String candidate, bool isMale) async {
//     if ((isMale && hasVotedMale) || (!isMale && hasVotedFemale)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('You have already voted for this category')),
//       );
//       return;
//     }

//     setState(() {
//       if (isMale) {
//         maleCandidates[candidate] = (maleCandidates[candidate] ?? 0) + 1;
//         hasVotedMale = true;
//       } else {
//         femaleCandidates[candidate] = (femaleCandidates[candidate] ?? 0) + 1;
//         hasVotedFemale = true;
//       }
//     });

//     try {
//       String gender = isMale ? 'Male' : 'Female';
//       DocumentSnapshot doc = await _firestore.collection('candidate')
//           .where('firstName', isEqualTo: candidate.split(' ')[0])
//           .where('lastName', isEqualTo: candidate.split(' ')[1])
//           .where('gender', isEqualTo: gender)
//           .where('department', isEqualTo: widget.department)
//           .limit(1)
//           .get()
//           .then((querySnapshot) => querySnapshot.docs.first);

//       await _firestore.collection('candidate').doc(doc.id).update({
//         'vote': FieldValue.increment(1),
//       });

//       await _firestore.collection('votes').doc(userId).set({
//         'votedMale': hasVotedMale,
//         'votedFemale': hasVotedFemale,
//       }, SetOptions(merge: true));
//     } catch (e) {
//       print('Error updating vote: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     int totalMaleVotes = maleCandidates.values.isNotEmpty
//         ? maleCandidates.values.reduce((a, b) => a + b)
//         : 0;
//     int totalFemaleVotes = femaleCandidates.values.isNotEmpty
//         ? femaleCandidates.values.reduce((a, b) => a + b)
//         : 0;

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Vote for Candidates - ${widget.department}'),
//       ),
//       body: Container(
//         color: Colors.purple[100],
//         padding: const EdgeInsets.all(16.0),
//         child: ListView(
//           children: [
//             Text(
//               'Vote for Male Candidate',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ...maleCandidates.entries.map((entry) {
//               double percentage = (totalMaleVotes > 0)
//                   ? (entry.value / totalMaleVotes) * 100
//                   : 0.0;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${entry.key}: ${entry.value} votes',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => vote(entry.key, true),
//                           child: Text('Vote'),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4),
//                     LinearProgressIndicator(
//                       value: totalMaleVotes > 0
//                           ? entry.value / totalMaleVotes
//                           : 0.0,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
//                     ),
//                     SizedBox(height: 4),
//                     Text('${percentage.toStringAsFixed(2)}%'),
//                   ],
//                 ),
//               );
//             }).toList(),
//             SizedBox(height: 20),
//             Text(
//               'Vote for Female Candidate',
//               style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 20),
//             ...femaleCandidates.entries.map((entry) {
//               double percentage = (totalFemaleVotes > 0)
//                   ? (entry.value / totalFemaleVotes) * 100
//                   : 0.0;
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           '${entry.key}: ${entry.value} votes',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                         ElevatedButton(
//                           onPressed: () => vote(entry.key, false),
//                           child: Text('Vote'),
//                         ),
//                       ],
//                     ),
//                     SizedBox(height: 4),
//                     LinearProgressIndicator(
//                       value: totalFemaleVotes > 0
//                           ? entry.value / totalFemaleVotes
//                           : 0.0,
//                       backgroundColor: Colors.grey[300],
//                       valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
//                     ),
//                     SizedBox(height: 4),
//                     Text('${percentage.toStringAsFixed(2)}%'),
//                   ],
//                 ),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }
// }
