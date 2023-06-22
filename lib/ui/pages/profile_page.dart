import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  static const route = '/profile';

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late AuthProvider authProvider;
  late String username;
  late String userPhoto;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();

    username = authProvider.getUserNickname()!;
    userPhoto = authProvider.getUserPhoto()!;
  }

  Future<void> handleSignOut() async {
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
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Profile',
          style: kTitle,
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            CircleAvatar(
              radius: 60,
              backgroundImage: CachedNetworkImageProvider(userPhoto),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              username,
              style: kTitle,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Saya suka ngoding',
              style: kSubtitle,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: kColorOrange),
              onPressed: () {
                handleSignOut();
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
