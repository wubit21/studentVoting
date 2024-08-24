import 'package:finalproj/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:finalproj/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FirebaseService.initialize();
  runApp(MyApp());
}

class addToStudentUnion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Class Representative Voting',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AddToStudentUnionScreen(),
    );
  }
}

class AddToStudentUnionScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addHighestVoteToStudentUnion() async {
    try {
      // Fetch all unique departments from the candidate collection
      QuerySnapshot departmentsSnapshot = await _firestore.collection('candidate').get();
      Set<String> departments = {};
      for (QueryDocumentSnapshot doc in departmentsSnapshot.docs) {
        departments.add(doc['department']);
      }

      // Process each department to find the highest voted male and female candidates
      for (String department in departments) {
        // Fetch all male candidates for the department
        QuerySnapshot maleCandidatesSnapshot = await _firestore
            .collection('candidate')
            .where('department', isEqualTo: department)
            .where('gender', isEqualTo: 'Male')
            .get();

        // Fetch all female candidates for the department
        QuerySnapshot femaleCandidatesSnapshot = await _firestore
            .collection('candidate')
            .where('department', isEqualTo: department)
            .where('gender', isEqualTo: 'Female')
            .get();

        // Find the male candidate with the highest votes
        DocumentSnapshot? highestMaleVoteCandidate;
        int highestMaleVotes = -1;

        for (QueryDocumentSnapshot doc in maleCandidatesSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int voteCount = data['vote'] ?? 0;
          if (voteCount > highestMaleVotes) {
            highestMaleVotes = voteCount;
            highestMaleVoteCandidate = doc;
          }
        }

        // Find the female candidate with the highest votes
        DocumentSnapshot? highestFemaleVoteCandidate;
        int highestFemaleVotes = -1;

        for (QueryDocumentSnapshot doc in femaleCandidatesSnapshot.docs) {
          Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
          int voteCount = data['vote'] ?? 0;
          if (voteCount > highestFemaleVotes) {
            highestFemaleVotes = voteCount;
            highestFemaleVoteCandidate = doc;
          }
        }

        // Add highest voted male and female candidates to studentUnion collection
        if (highestMaleVoteCandidate != null) {
          Map<String, dynamic> maleCandidateData = highestMaleVoteCandidate.data() as Map<String, dynamic>;
          await _firestore.collection('studentUnion').add(maleCandidateData);
          print('Added highest voted male candidate from $department to studentUnion collection: $maleCandidateData');
        }

        if (highestFemaleVoteCandidate != null) {
          Map<String, dynamic> femaleCandidateData = highestFemaleVoteCandidate.data() as Map<String, dynamic>;
          await _firestore.collection('studentUnion').add(femaleCandidateData);
          print('Added highest voted female candidate from $department to studentUnion collection: $femaleCandidateData');
        }
      }

      print('Highest voted candidates added to studentUnion collection for all departments');
    } catch (e) {
      print('Error adding highest voted candidates: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add to Student Union'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: addHighestVoteToStudentUnion,
          child: Text('Add Highest Votes to Student Union'),
        ),
      ),
    );
  }
}