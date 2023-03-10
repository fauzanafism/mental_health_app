import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health_app/ui/pages/login_page.dart';
import 'package:mental_health_app/ui/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        builder: (context, child) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Mental Health App',
            initialRoute: LoginPage.route,
            routes: {
              LoginPage.route: (context) => const LoginPage(),
              MainPage.route: (context) => const MainPage()
            },
            // theme: ThemeData(useMaterial3: true),
          );
        });
  }
}
