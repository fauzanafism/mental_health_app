import 'package:flutter/material.dart';
import 'package:mental_health_app/ui/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mental Health App',
      initialRoute: '/',
      routes: {'/': (context) => const MainPage()},
    );
  }
}
