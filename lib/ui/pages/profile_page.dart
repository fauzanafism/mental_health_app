import 'package:flutter/material.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/login_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const route = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<void> handleSignOut() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    authProvider.handleSignOut();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () {
            handleSignOut();
          },
          child: const Text("Logout"),
        ),
      ),
    );
  }
}
