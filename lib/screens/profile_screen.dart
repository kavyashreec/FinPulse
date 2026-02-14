import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
      ),
      body: user == null
          ? const Center(child: Text("No user logged in"))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Name
                  Text(
                    "Name",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  Text(
                    user.displayName ?? "Not set",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  // Email
                  Text(
                    "Email",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  Text(
                    user.email ?? "",
                    style: const TextStyle(fontSize: 18),
                  ),

                  const SizedBox(height: 20),

                  // UID
                  Text(
                    "User ID",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600),
                  ),
                  Text(
                    user.uid,
                    style: const TextStyle(fontSize: 14),
                  ),

                  const Spacer(),

                  // Logout button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                          (route) => false,
                        );
                      },
                      child: const Text("Logout"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
