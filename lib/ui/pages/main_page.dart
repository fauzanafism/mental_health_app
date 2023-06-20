import 'dart:io';
import 'dart:ui';

import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/pages.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  static const String route = '/home';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late AuthProvider authProvider;
  late String currentUserId;
  late String userPhoto;

  final List<TabItem> items = [
    const TabItem(icon: Icons.home),
    const TabItem(icon: Icons.map),
    const TabItem(icon: Icons.chat_bubble),
    const TabItem(icon: Icons.people),
  ];

  int visit = 0;
  DateTime? ctime;

  final List<Widget> widgetOptions = [
    const Home(),
    const Session(),
    const ListChatPage(),
    const WellnessPage(),
  ];

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();

    if (authProvider.getFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseId()!;
      userPhoto = authProvider.getUserPhoto()!;
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
    return WillPopScope(
      onWillPop: () {
        DateTime now = DateTime.now();
        if (ctime == null ||
            now.difference(ctime!) > const Duration(seconds: 2)) {
          ctime = now;
          Fluttertoast.showToast(msg: 'Press back button again to exit');
          return Future.value(false);
        }
        exit(0);
      },
      child: Scaffold(
          // extendBodyBehindAppBar: true,
          appBar: AppBar(
            flexibleSpace: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
            // actions: [
            //   badge.Badge(
            //     badgeContent: Text(
            //       '3',
            //       textAlign: TextAlign.center,
            //       style: kBodyText.copyWith(color: Colors.white, fontSize: 10),
            //     ),
            //     position: badge.BadgePosition.topEnd(top: 5, end: 8),
            //     badgeStyle: const badge.BadgeStyle(badgeColor: kColorOrange),
            //     child: IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.notifications_none_rounded,
            //         size: 30,
            //       ),
            //       color: kColorBrown,
            //     ),
            //   )
            // ],
            backgroundColor: Colors.white.withAlpha(200),
            leading: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, ProfilePage.route);
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: CircleAvatar(
                  backgroundImage: CachedNetworkImageProvider(userPhoto),
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
              colorSelected: kColorOrange)),
    );
  }
}
