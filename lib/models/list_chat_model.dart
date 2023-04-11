import 'package:cloud_firestore/cloud_firestore.dart';

class ListChatModel {
  String id;
  String nickname;
  String photoUrl;
  String timestamp;
  String content;
  bool isMe;
  int type;

  ListChatModel(
      {required this.nickname,
      required this.id,
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
      "isMe": isMe,
      "id": id
    };
  }

  factory ListChatModel.fromJson(Map<String, dynamic> doc) {
    String nickname = doc["nickname"];
    String id = doc['id'];
    String photoUrl = doc["photoUrl"];
    String timestamp = doc["timestamp"].toString();
    String content = doc["content"];
    int type = doc["type"];
    bool isMe = doc["isMe"];

    return ListChatModel(
        id: id,
        nickname: nickname,
        photoUrl: photoUrl,
        timestamp: timestamp,
        content: content,
        type: type,
        isMe: isMe);
  }
}
