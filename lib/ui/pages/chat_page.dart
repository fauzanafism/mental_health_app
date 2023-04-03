import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/models/message_chat.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/chat_provider.dart';
import 'package:mental_health_app/ui/pages/login_page.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final ChatPageArguments arguments;

  const ChatPage({super.key, required this.arguments});

  static const route = '/chat_page';

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late String currentUserId;

  List<QueryDocumentSnapshot> listMessage = [];

  String groupChatId = "";

  File? imageFile;
  bool isLoading = false;
  bool isShowSticker = false;
  String imageUrl = "";

  final TextEditingController textEditingController = TextEditingController();
  final FocusNode focusNode = FocusNode();

  late ChatProvider chatProvider;
  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

    focusNode.addListener(() {});
    readLocal();
  }

  void readLocal() {
    if (authProvider.getFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseId()!;
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false);
    }
    String peerId = widget.arguments.peerId;
    if (currentUserId.compareTo(peerId) > 0) {
      groupChatId = '$currentUserId-$peerId';
    } else {
      groupChatId = '$peerId-$currentUserId';
    }

    chatProvider.updateDataFirestore(
        collectionPath: 'user',
        docPath: currentUserId,
        dataNeedUpdate: {'chattingWith': peerId});
  }

  void onSendMessage(String content, int type) {
    if (content.trim().isNotEmpty) {
      textEditingController.clear();
      chatProvider.sendMessage(
          content, type, groupChatId, currentUserId, widget.arguments.peerId);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send', backgroundColor: kColorIconGrey);
    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") == currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 && listMessage[index - 1].get("idFrom") != currentUserId) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: Image.network(
                widget.arguments.peerAvatar,
                fit: BoxFit.cover,
                width: 35,
                height: 35,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  }
                  return SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: Colors.green,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    )),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.account_circle,
                  size: 35,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(widget.arguments.peerNickname),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [buildListMessage(), buildInput()],
            ),
          ],
        ),
      ),
    );
  }

  Flexible buildListMessage() {
    return Flexible(
        child: groupChatId.isNotEmpty
            ? StreamBuilder<QuerySnapshot>(
                stream: chatProvider.getChatStream(groupChatId, 20),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    listMessage = snapshot.data!.docs;
                    if (listMessage.isNotEmpty) {
                      return ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: snapshot.data?.docs.length,
                        reverse: true,
                        itemBuilder: (context, index) =>
                            buildItem(index, snapshot.data?.docs[index]),
                      );
                    } else {
                      return const Center(
                        child: Text('No message here yet...'),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              )
            : const Center(
                child: CircularProgressIndicator(
                  color: kColorOrange,
                ),
              ));
  }

  Widget buildItem(int index, DocumentSnapshot? document) {
    if (document != null) {
      MessageChat messageChat = MessageChat.fromDocument(document);
      if (messageChat.idFrom == currentUserId) {
        // My message (Right)
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            messageChat.type == TypeMessage.text
                ? Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    margin: EdgeInsets.only(
                        bottom: isLastMessageRight(index) ? 20 : 10, right: 10),
                    width: 200,
                    decoration: BoxDecoration(
                        color: kColorGrey,
                        borderRadius: BorderRadius.circular(8)),
                    child: Text(messageChat.content),
                  )
                : messageChat.type == TypeMessage.image
                    ? SizedBox(
                        width: 200,
                        height: 200,
                        child: Image.network(messageChat.content),
                      )
                    : Container()
          ],
        );
      } else {
        // Peer message (Left)
        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  messageChat.type == TypeMessage.text
                      ? Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: 200,
                          decoration: BoxDecoration(
                              color: kColorIconGrey,
                              borderRadius: BorderRadius.circular(8)),
                          margin: const EdgeInsets.only(left: 10),
                          child: Text(messageChat.content),
                        )
                      : messageChat.type == TypeMessage.image
                          ? SizedBox(
                              width: 200,
                              height: 200,
                              child: Image.network(messageChat.content),
                            )
                          : Container(),
                ],
              ),
              isLastMessageLeft(index)
                  ? Container(
                      margin:
                          const EdgeInsets.only(left: 15, top: 5, bottom: 5),
                      child: Text(
                        DateFormat('dd MMMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                            int.parse(messageChat.timestamp),
                          ),
                        ),
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            color: kColorSoftGrey,
                            fontSize: 12),
                      ),
                    )
                  : const SizedBox.shrink()
            ],
          ),
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Container buildInput() {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: kColorIconGrey, width: 0.5)),
          color: Colors.white),
      child: Row(
        children: [
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.image),
                onPressed: () {},
                color: kColorOrange,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 1),
              child: IconButton(
                icon: const Icon(Icons.face),
                onPressed: () {},
                color: kColorOrange,
              ),
            ),
          ),
          Flexible(
            child: Container(
              child: TextField(
                onSubmitted: (value) {},
                controller: textEditingController,
                decoration: const InputDecoration.collapsed(
                    hintText: 'Type your message...',
                    hintStyle: TextStyle(color: kColorIconGrey)),
                focusNode: focusNode,
                autofocus: true,
              ),
            ),
          ),
          Material(
            color: Colors.white,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: IconButton(
                icon: const Icon(Icons.send),
                onPressed: () =>
                    onSendMessage(textEditingController.text, TypeMessage.text),
                color: kColorOrange,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ChatPageArguments {
  final String peerId;
  final String peerAvatar;
  final String peerNickname;

  ChatPageArguments(this.peerId, this.peerAvatar, this.peerNickname);
}
