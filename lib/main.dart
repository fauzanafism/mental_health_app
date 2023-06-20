import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/providers/providers.dart';
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
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  MyApp({Key? key, required this.prefs}) : super(key: key);

  // TODO: Buat group chat? branch main
  // TODO: Buat sistem local notification? branch main
  // TODO: Tab 4 masih belum tau buat apaan

  void registerNotification() {
    firebaseMessaging.requestPermission();

    firebaseMessaging.getToken().then((token) {
      firebaseFirestore
          .collection('users')
          .doc('currentUserId')
          .update({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthProvider>(
                create: (_) => AuthProvider(
                    googleSignIn: GoogleSignIn(),
                    firebaseAuth: FirebaseAuth.instance,
                    firebaseFirestore: firebaseFirestore,
                    prefs: prefs),
              ),
              Provider<ListUserProvider>(
                create: (context) => ListUserProvider(firebaseFirestore),
              ),
              Provider<ChatProvider>(
                create: (context) => ChatProvider(
                    prefs: prefs,
                    firebaseFirestore: firebaseFirestore,
                    firebaseStorage: firebaseStorage),
              )
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'RML App',
              initialRoute: Wrapper.route,
              routes: {
                Wrapper.route: (context) => const Wrapper(),
                LoginPage.route: (context) => const LoginPage(),
                MainPage.route: (context) => const MainPage(),
                ProfilePage.route: (context) => const ProfilePage(),
                AddChatPage.route: (context) => const AddChatPage(),
                ChatPage.route: (context) => ChatPage(
                    arguments: ModalRoute.of(context)?.settings.arguments
                        as ChatPageArguments)
              },
              // theme: ThemeData(useMaterial3: true),
            ),
          );
        });
  }
}
