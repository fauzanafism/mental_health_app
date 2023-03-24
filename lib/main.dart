import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/pages/pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(
    prefs: prefs,
  ));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (_) => AuthProvider(
                    googleSignIn: GoogleSignIn(),
                    firebaseAuth: FirebaseAuth.instance,
                    firebaseFirestore: firebaseFirestore,
                    prefs: prefs),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Mental Health App',
              initialRoute: LoginPage.route,
              routes: {
                LoginPage.route: (context) => const LoginPage(),
                MainPage.route: (context) => const MainPage(),
                ProfilePage.route: (context) => const ProfilePage()
              },
              // theme: ThemeData(useMaterial3: true),
            ),
          );
        });
  }
}
