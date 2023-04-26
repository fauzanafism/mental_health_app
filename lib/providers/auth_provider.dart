import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mental_health_app/models/user_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status {
  uninitialized,
  authenticated,
  authenticating,
  authenticateError,
  authenticateException,
  authenticateCanceled
}

class AuthProvider extends ChangeNotifier {
  final GoogleSignIn googleSignIn;
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final SharedPreferences prefs;

  AuthProvider({
    required this.googleSignIn,
    required this.firebaseAuth,
    required this.firebaseFirestore,
    required this.prefs,
  });

  Status _status = Status.uninitialized;

  Status get status => _status;

  Future<bool> handleSignIn() async {
    _status = Status.authenticating;
    notifyListeners();

    GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    if (googleUser != null) {
      GoogleSignInAuthentication? googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      User? firebaseUser =
          (await firebaseAuth.signInWithCredential(credential)).user;

      if (firebaseUser != null) {
        final QuerySnapshot result = await firebaseFirestore
            .collection("user")
            .where("id", isEqualTo: firebaseUser.uid)
            .get();
        final List<DocumentSnapshot> documents = result.docs;
        if (documents.isEmpty) {
          firebaseFirestore.collection("user").doc(firebaseUser.uid).set({
            "nickname": firebaseUser.displayName,
            "photoUrl": firebaseUser.photoURL,
            "id": firebaseUser.uid,
            "createdAt": DateTime.now().millisecondsSinceEpoch.toString(),
            "chattingWith": null
          });

          User? currentUser = firebaseUser;
          await prefs.setString("id", currentUser.uid);
          await prefs.setString("nickname", currentUser.displayName ?? "");
          await prefs.setString("photoUrl", currentUser.photoURL ?? "");
        } else {
          DocumentSnapshot documentSnapshot = documents[0];
          UserChat userChat = UserChat.fromDocument(documentSnapshot);

          await prefs.setString("id", userChat.id);
          await prefs.setString("nickname", userChat.nickname);
          await prefs.setString("photoUrl", userChat.photoUrl);
        }
        _status = Status.authenticated;
        notifyListeners();
        return true;
      } else {
        _status = Status.authenticateError;
        notifyListeners();
        return false;
      }
    } else {
      _status = Status.authenticateCanceled;
      notifyListeners();
      return false;
    }
  }

  String? getFirebaseId() {
    return prefs.getString("id");
  }

  String? getUserNickname() {
    return prefs.getString("nickname");
  }

  String? getUserPhoto() {
    return prefs.getString("photoUrl");
  }

  Future<bool> isLoggedIn() async {
    bool isLoggedIn = await googleSignIn.isSignedIn();
    if (isLoggedIn && prefs.getString("id")?.isNotEmpty == true) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> handleSignOut() async {
    _status = Status.uninitialized;
    await firebaseAuth.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();
  }

  void handleException() {
    _status = Status.authenticateException;
    notifyListeners();
  }
}
