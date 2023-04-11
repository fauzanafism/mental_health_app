import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/models/list_chat_model.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/chat_provider.dart';
import 'package:mental_health_app/ui/widgets/loading_view.dart';
import 'package:provider/provider.dart';

import 'pages.dart';

class ListChatPage extends StatefulWidget {
  const ListChatPage({super.key});

  @override
  State<ListChatPage> createState() => _ListChatPageState();
}

class _ListChatPageState extends State<ListChatPage> {
  late AuthProvider authProvider;
  late ChatProvider chatProvider;

  late String currentUserId;

  String groupChatId = '';

  @override
  void initState() {
    super.initState();
    chatProvider = context.read<ChatProvider>();
    authProvider = context.read<AuthProvider>();

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
    chatProvider.getDocumentsName(currentUserId);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 6 / 8 + 10,
      child: Stack(
        children: [
          Flexible(
            child: StreamBuilder<DocumentSnapshot>(
                stream: chatProvider.getRecentChatStream(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.data() != null) {
                      var data = snapshot.data!.data() as Map<String, dynamic>;
                      var indices = data.keys.toList();
                      return ListView.builder(
                        itemCount: indices.length,
                        itemBuilder: (context, index) {
                          var peer = ListChatModel.fromJson(
                              data[indices[index]] as Map<String, dynamic>);

                          return ChatList(
                            isMe: peer.isMe,
                            imageUrl: peer.photoUrl,
                            message: peer.content,
                            time: DateFormat('dd MMMM kk:mm').format(
                              DateTime.fromMillisecondsSinceEpoch(
                                int.parse(peer.timestamp),
                              ),
                            ),
                            username: peer.nickname,
                            onTap: () {
                              Navigator.pushNamed(context, ChatPage.route,
                                  arguments: ChatPageArguments(
                                      peer.id, peer.photoUrl, peer.nickname));
                            },
                          );
                        },
                      );
                    } else {
                      return const Center(
                        child: Text('No message here...'),
                      );
                    }
                  } else {
                    return const LoadingView();
                  }
                }),
          ),
          Positioned(
              bottom: 1,
              right: 1,
              child: FloatingActionButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddChatPage.route);
                },
                backgroundColor: kColorOrange,
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ))
        ],
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String message;
  final String time;
  final bool isMe;
  final void Function() onTap;

  const ChatList({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.message,
    required this.time,
    required this.isMe,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: NetworkImage(imageUrl)),
          onTap: onTap,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                username,
                style: kBodyTextRubik.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w600),
              ),
              Text(
                time,
                style: kBodyTextRubik.copyWith(color: kColorSoftGrey),
              )
            ],
          ),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              children: [
                isMe ? const Icon(Icons.check_sharp) : Container(),
                const SizedBox(width: 5),
                Text(
                  message,
                  overflow: TextOverflow.ellipsis,
                  style:
                      kBodyTextRubik.copyWith(fontSize: 13, color: kColorBrown),
                ),
              ],
            ),
          ),
        ),
        const Divider()
      ],
    );
  }
}
