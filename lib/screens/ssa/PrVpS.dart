import 'package:finalproj/firebase_service.dart';
import 'package:finalproj/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class ElectedStudents extends StatefulWidget {
  @override
  _ElectedStudentsState createState() => _ElectedStudentsState();
}

class _ElectedStudentsState extends State<ElectedStudents> {
  final CollectionReference _candidatesRef =
      FirebaseFirestore.instance.collection('presidentCandidate');
  final CollectionReference _electedStudentsRef =
      FirebaseFirestore.instance.collection('electedStudents');
  List<Map<String, dynamic>> _topCandidates = [];

  @override
  void initState() {
    super.initState();
    _fetchTopCandidates();
  }

  Future<void> _fetchTopCandidates() async {
    QuerySnapshot querySnapshot = await _candidatesRef.get();
    List<Map<String, dynamic>> candidates = querySnapshot.docs.map((doc) {
      double exam = (doc['exam'] ?? 0) / 50 * 10; // Exam out of 50, 10%
      double presentation = (doc['presentation'] ?? 0) / 15 * 15; // Presentation out of 15, 15%
      double interview = (doc['interview'] ?? 0) / 15 * 10; // Interview out of 15, 10%
      double certificate = (doc['certificate'] ?? false) ? 5 : 0; // Certificate, 5%
      double vote = (doc['vote'] ?? 0) / 100 * 60; // Vote out of 100, 60%

      double totalScore = exam + presentation + interview + certificate + vote;

      return {
        'id': doc.id,
        'name': doc['name'],
        'exam': exam,
        'presentation': presentation,
        'interview': interview,
        'certificate': certificate,
        'vote': vote,
        'totalScore': totalScore,
      };
    }).toList();

    candidates.sort((a, b) => b['totalScore'].compareTo(a['totalScore']));

    setState(() {
      _topCandidates = candidates.take(3).toList();
    });

    _addTopCandidatesToElectedStudents(_topCandidates);
  }

  Future<void> _addTopCandidatesToElectedStudents(List<Map<String, dynamic>> topCandidates) async {
    const positions = ['President', 'Vice-President', 'Secretary'];
    for (var i = 0; i < topCandidates.length; i++) {
      var candidate = topCandidates[i];
      await _electedStudentsRef.add({
        'id': candidate['id'],
        'name': candidate['name'],
        'exam': candidate['exam'],
        'presentation': candidate['presentation'],
        'interview': candidate['interview'],
        'certificate': candidate['certificate'],
        'vote': candidate['vote'],
        'totalScore': candidate['totalScore'],
        'position': positions[i],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Elected Students'),
        backgroundColor: Colors.purple[100],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            width: 800, // Adjusted width for the box
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Top three Elected Students:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 11, 11, 11),
                  ),
                ),
                SizedBox(height: 20),
                ..._topCandidates.map((candidate) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(candidate['name'] ,),
                              
                              SizedBox(height: 4),
                              Text('Total Score: ${candidate['totalScore']}'),
                            ],
                            
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
      bottomNavigationBar: BottomAppBar(
        color: Colors.purple[50], // Set the background color of the footer
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
