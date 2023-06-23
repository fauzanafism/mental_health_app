import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mental_health_app/models/list_chat_model.dart';
import 'package:mental_health_app/models/message_chat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatProvider {
  final SharedPreferences prefs;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  List<String> documentList = [];

  List<String> peerList = [];

  ChatProvider(
      {required this.prefs,
      required this.firebaseFirestore,
      required this.firebaseStorage});

  String? getPref(String key) {
    return prefs.getString(key);
  }

  Future<void> updateDataFirestore(
      {required String collectionPath,
      required String docPath,
      required Map<String, dynamic> dataNeedUpdate}) async {
    return firebaseFirestore
        .collection(collectionPath)
        .doc(docPath)
        .update(dataNeedUpdate);
  }

  void getDocumentsName(String currentUserId) async {
    final result = await firebaseFirestore
        .collection('messages')
        .where('member', arrayContains: currentUserId)
        .get();
    final documents = result.docs;
    for (var element in documents) {
      documentList.add(element.id);
    }
  }

  // Stream<QuerySnapshot> getLatestChatStream(
  //     String currentUserId, String peerId) {
  //   getDocumentsName(currentUserId);

  //   List data = [];

  //   for (var element in documentList) {
  //     firebaseFirestore
  //         .collection('messages')
  //         .doc(element)
  //         .collection('messages')
  //         .orderBy('timestamp', descending: true)
  //         .get()
  //         .then((value) => data.add(value));
  //   }
  // }

  Stream<DocumentSnapshot> getRecentChatStream(String currentUserId) {
    return firebaseFirestore
        .collection('recentChat')
        .doc(currentUserId)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatStream(String groupChatId, int limit) {
    return firebaseFirestore
        .collection("messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }

  UploadTask uploadFile(File image, String fileName) {
    Reference reference = firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(image);
    return uploadTask;
  }

  void sendMessage(String content, int type, String groupChatId,
      String currentUserId, String peerId) async {
    DocumentReference documentReference = firebaseFirestore
        .collection("messages")
        .doc(groupChatId)
        .collection(groupChatId)
        .doc(DateTime.now().millisecondsSinceEpoch.toString());

    DocumentReference recentChatUser =
        firebaseFirestore.collection("recentChat").doc(currentUserId);

    DocumentReference recentChatPeer =
        firebaseFirestore.collection("recentChat").doc(peerId);

    MessageChat messageChat = MessageChat(
        idFrom: currentUserId,
        idTo: peerId,
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type);

    DocumentSnapshot documentPeer =
        await firebaseFirestore.collection('user').doc(peerId).get();

    var peerProfile = documentPeer.data() as Map<String, dynamic>;

    bool isMe = true;

    String? userNick() {
      return prefs.getString('nickname');
    }

    String? userPhoto() {
      return prefs.getString('photoUrl');
    }

    ListChatModel listChatModel = ListChatModel(
        id: peerId,
        nickname: peerProfile['nickname'],
        photoUrl: peerProfile['photoUrl'],
        timestamp: DateTime.now().millisecondsSinceEpoch.toString(),
        content: content,
        type: type,
        isMe: isMe);

    // Map<String, dynamic> docField = {};

    // await firebaseFirestore
    //     .collection("messages")
    //     .doc(groupChatId)
    //     .get()
    //     .then((value) {
    //   if (value.data() != null) {
    //     docField = value.data() as Map<String, dynamic>;
    //   } else {
    //     docField = {};
    //   }
    // });

    // if (docField.isEmpty) {
    //   FirebaseFirestore.instance.runTransaction((transaction) async {
    //     transaction
    //         .set(firebaseFirestore.collection("messages").doc(groupChatId), {
    //       "member": [messageChat.idTo, messageChat.idFrom]
    //     });
    //   });
    // }

    // Input data message ke collection message
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(documentReference, messageChat.toJson());
    });

    var listDoc = await firebaseFirestore
        .collection('recentChat')
        .get()
        .then((value) => value.docs.map((e) => e.id).toList());

    if (!listDoc.contains(currentUserId)) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.set(recentChatUser, {peerId: listChatModel.toJson()});
      });
    }

    // Input data ke collection recentChat user
    if (listDoc.contains(currentUserId)) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction.update(recentChatUser, {peerId: listChatModel.toJson()});
      });
    }

    listChatModel.isMe = false;
    listChatModel.nickname = userNick()!;
    listChatModel.photoUrl = userPhoto()!;
    listChatModel.id = currentUserId;

    if (!listDoc.contains(peerId)) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction
            .set(recentChatPeer, {currentUserId: listChatModel.toJson()});
      });
    }

    // Input data ke collection recentChat peer
    if (listDoc.contains(peerId)) {
      await FirebaseFirestore.instance.runTransaction((transaction) async {
        transaction
            .update(recentChatPeer, {currentUserId: listChatModel.toJson()});
      });
    }
  }
}

class TypeMessage {
  static const text = 0;
  static const image = 1;
  static const sticker = 2;
  static const document = 3;
  static const video = 4;
}
