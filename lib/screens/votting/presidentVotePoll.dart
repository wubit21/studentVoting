import 'package:finalproj/firebase_service.dart';
import 'package:finalproj/main.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  await FirebaseService.initialize();
  runApp(MyApp());
}

class VotePresident extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PollScreen(),
    );
  }
}

class PollScreen extends StatefulWidget {
  @override
  _PollScreenState createState() => _PollScreenState();
}

class _PollScreenState extends State<PollScreen> {
  final CollectionReference _candidatesRef =
      FirebaseFirestore.instance.collection('presidentCandidate');
  List<Map<String, dynamic>> _candidates = [];

  @override
  void initState() {
    super.initState();
    _fetchCandidates();
  }

  Future<void> _fetchCandidates() async {
    QuerySnapshot querySnapshot = await _candidatesRef.get();
    setState(() {
      _candidates = querySnapshot.docs
          .map((doc) => {
                'id': doc.id,
                'name': doc['name'],
                'vote': doc['vote'] ?? 0,
              })
          .toList();
    });
  }

  void _vote(String id) async {
    DocumentReference candidateRef = _candidatesRef.doc(id);
    DocumentSnapshot candidateSnapshot = await candidateRef.get();
    int currentVotes = candidateSnapshot['vote'] ?? 0;
    candidateRef.update({'vote': currentVotes + 1});

    _fetchCandidates(); // Refresh the candidate list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Active Poll'),
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
                  'Vote for your favorite candidate:',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: const Color.fromARGB(255, 11, 11, 11),
                  ),
                ),
                SizedBox(height: 20),
                ..._candidates.map((candidate) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(candidate['name']),
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
                                    widthFactor: candidate['vote'] / 100,
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
                              Text('${candidate['vote']} votes'),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        ElevatedButton(
                          onPressed: () => _vote(candidate['id']),
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
