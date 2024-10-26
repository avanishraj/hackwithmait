import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackwithinfy/Authentication/login_page.dart';
import 'package:hackwithinfy/SOS/sos.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('users').doc(uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('No profile data found.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(child: Icon(Icons.person_2, size: 50)),
                  SizedBox(height: 16),
                  Text(
                    '${data['firstName']} ${data['lastName']}',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 24),
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.email, color: Colors.blueAccent),
                      title: Text(data['email']),
                      subtitle: Text('Email'),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    child: ListTile(
                      leading: Icon(Icons.phone, color: Colors.blueAccent),
                      title: Text(data['contactNumber']),
                      subtitle: Text('Phone'),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SOSButton(contactNo: data['contactNumber']),
                      GestureDetector(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                            (Route<dynamic> route) => false,
                          );
                        },
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10),
                            child: Text(
                              "Logout",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                          decoration: BoxDecoration(color: Colors.blue, borderRadius: BorderRadius.circular(15)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}