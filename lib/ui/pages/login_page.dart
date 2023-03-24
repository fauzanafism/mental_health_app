import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/ui/pages/pages.dart';
import 'package:mental_health_app/ui/widgets/loading_view.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static const String route = '/';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    AuthProvider authProvider = Provider.of<AuthProvider>(context);
    switch (authProvider.status) {
      case Status.authenticated:
        Fluttertoast.showToast(msg: "Sign in success");
        break;
      case Status.authenticateError:
        Fluttertoast.showToast(msg: "Sign in fail");
        break;
      case Status.authenticateCanceled:
        Fluttertoast.showToast(msg: "Sign in canceled");
        break;
      default:
        break;
    }

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
                TextButton(
                    onPressed: () async {
                      authProvider.handleSignIn().then((isSuccess) {
                        if (isSuccess) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainPage(),
                              ));
                        }
                      }).catchError((error, stackTrace) {
                        Fluttertoast.showToast(msg: error.toString());
                        authProvider.handleException();
                      });
                    },
                    child: const Text('LOGIN'))
              ],
            ),
          ),
          Positioned(
            child: authProvider.status == Status.authenticating
                ? const LoadingView()
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
