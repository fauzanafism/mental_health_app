import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:badges/badges.dart' as badge;
import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/chat_page.dart';
import 'package:mental_health_app/ui/pages/login_page.dart';
import 'package:mental_health_app/ui/pages/profile_page.dart';
import 'package:mental_health_app/ui/pages/session_page.dart';
import 'package:mental_health_app/ui/pages/wellness_page.dart';
import 'package:provider/provider.dart';

import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const String route = '/home';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late AuthProvider authProvider;
  late String currentUserId;

  final List<TabItem> items = [
    const TabItem(icon: Icons.home),
    const TabItem(icon: Icons.videocam),
    const TabItem(icon: Icons.chat_bubble),
    const TabItem(icon: Icons.people),
  ];

  int visit = 0;

  final List<Widget> widgetOptions = [
    const Home(),
    const Session(),
    const ChatPage(),
    const WellnessPage(),
  ];

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();

    if (authProvider.getFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseId()!;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            badge.Badge(
              badgeContent: Text(
                '3',
                textAlign: TextAlign.center,
                style: kBodyText.copyWith(color: Colors.white, fontSize: 10),
              ),
              position: badge.BadgePosition.topEnd(top: 5, end: 8),
              badgeStyle: const badge.BadgeStyle(badgeColor: kColorOrange),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  size: 30,
                ),
                color: kColorBrown,
              ),
            )
          ],
          backgroundColor: Colors.white,
          leading: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ProfilePage.route);
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: CircleAvatar(
                backgroundImage: AssetImage('assets/images/pp.jpeg'),
              ),
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            child: widgetOptions.elementAt(visit),
          ),
        ),
        bottomNavigationBar: BottomBarInspiredFancy(
            onTap: (index) {
              setState(() {
                visit = index;
              });
            },
            indexSelected: visit,
            items: items,
            iconSize: 40,
            styleIconFooter: StyleIconFooter.dot,
            backgroundColor: Colors.white,
            color: kColorGrey,
            colorSelected: kColorOrange));
  }
}
