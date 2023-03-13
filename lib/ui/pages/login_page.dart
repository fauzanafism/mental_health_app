import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/ui/pages/main_page.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: const Color(0xff53A06E),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('YOUR',
                        style: kTitle.copyWith(
                            color: Colors.white, fontSize: 40.sp)),
                    Text('LOVELY HOME',
                        style: kTitle.copyWith(
                            color: Colors.white, fontSize: 46.sp)),
                  ],
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, MainPage.route);
                    },
                    child: const Text('LOGIN'))
              ],
            ),
          )
        ],
      ),
    );
  }
}
