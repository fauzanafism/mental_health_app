// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({super.key});
  static const route = '/splash';

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      checkSignedIn();
    });
  }

  void checkSignedIn() async {
    AuthProvider authProvider = context.read<AuthProvider>();
    bool isLoggedIn = await authProvider.isLoggedIn();
    if (isLoggedIn) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const MainPage(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
