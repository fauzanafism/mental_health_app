import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image.asset("assets/images/rmllogo.png"),
                ElevatedButton(
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
