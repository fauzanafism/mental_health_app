import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/models/message_chat.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/chat_provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: kColorOrange,
        title: Text(widget.arguments.peerNickname),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Flexible(
                    child: groupChatId.isNotEmpty
                        ? StreamBuilder<QuerySnapshot>(
                            stream: chatProvider.getChatStream(groupChatId, 20),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                listMessage = snapshot.data!.docs;
                                if (listMessage.isNotEmpty) {
                                  return ListView.builder(
                                    padding: const EdgeInsets.all(10),
                                    itemBuilder: (context, index) {
                                      var document = snapshot.data!.docs[index];
                                      if (document != null) {
                                        MessageChat messageChat =
                                            MessageChat.fromDocument(document);
                                        if (messageChat.idFrom ==
                                            currentUserId) {
                                          // My message (Right)
                                          return Row(
                                            children: [
                                              messageChat.type ==
                                                      TypeMessage.text
                                                  ? Container(
                                                      child: Text(
                                                          messageChat.content),
                                                    )
                                                  : messageChat.type ==
                                                          TypeMessage.image
                                                      ? Container()
                                                      : Container()
                                            ],
                                          );
                                        } else {
                                          // Peer message (Left)
                                          return Container();
                                        }
                                      } else {
                                        return const SizedBox.shrink();
                                      }
                                    },
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
                            child: CircularProgressIndicator(),
                          ))
              ],
            ),
          ],
        ),
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
