import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.data() as Map<String, dynamic>;
  }

  @override
  Widget build(BuildContext context) {
    final User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: user != null ? _getUserData(user.uid) : null,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!snapshot.hasData) {
            return const Center(child: Text('No user data found'));
          }

          final userData = snapshot.data!;

          return Padding(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ),
                const SizedBox(height: 20),
                ListTile(
                  title: const Text("Name"),
                  subtitle: Text(userData['name'] ?? 'User'), // Retrieves name from Firestore
                  leading: const Icon(Icons.person),
                ),
                ListTile(
                  title: const Text("Email"),
                  subtitle: Text(user?.email ?? 'No email found'),
                  leading: const Icon(Icons.email),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pushNamed(context, '/login');
                  },
                  child: const Text("Logout"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pinkAccent,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}