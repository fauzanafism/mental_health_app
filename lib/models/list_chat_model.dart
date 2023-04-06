import 'package:cloud_firestore/cloud_firestore.dart';

class ListChatModel {
  String nickname;
  String photoUrl;
  String timestamp;
  String content;
  bool isMe;
  int type;

  ListChatModel(
      {required this.nickname,
      required this.photoUrl,
      required this.timestamp,
      required this.content,
      required this.type,
      required this.isMe});

  Map<String, dynamic> toJson() {
    return {
      "nickname": nickname,
      "photoUrl": photoUrl,
      "timestamp": timestamp,
      "content": content,
      "type": type,
      "isMe": isMe
    };
  }

  factory ListChatModel.fromJson(Map<String, dynamic> doc) {
    String nickname = doc["nickname"];
    String photoUrl = doc["photoUrl"];
    String timestamp = doc["timestamp"].toString();
    String content = doc["content"];
    int type = doc["type"];
    bool isMe = doc["isMe"];
    return ListChatModel(
        nickname: nickname,
        photoUrl: photoUrl,
        timestamp: timestamp,
        content: content,
        type: type,
        isMe: isMe);
  }
}
