import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/models/user_chat.dart';
import 'package:mental_health_app/providers/auth_provider.dart';
import 'package:mental_health_app/providers/list_user_provider.dart';
import 'package:mental_health_app/ui/pages/chat_page.dart';
import 'package:provider/provider.dart';

class AddChatPage extends StatefulWidget {
  const AddChatPage({super.key});
  static const route = '/add_chat';

  @override
  State<AddChatPage> createState() => _AddChatPageState();
}

class _AddChatPageState extends State<AddChatPage> {
  late ListUserProvider listUserProvider;
  late AuthProvider authProvider;
  late String currentUserId;

  String textSearch = '';

  @override
  void initState() {
    super.initState();
    listUserProvider = context.read<ListUserProvider>();
    authProvider = context.read<AuthProvider>();
    if (authProvider.getFirebaseId()?.isNotEmpty == true) {
      currentUserId = authProvider.getFirebaseId()!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add chat'),
          centerTitle: true,
          backgroundColor: kColorOrange,
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream:
                  listUserProvider.getStreamFirestore('user', 20, textSearch),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if ((snapshot.data?.docs.length ?? 0) > 0) {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        var doc = snapshot.data?.docs[index];
                        if (doc != null) {
                          UserChat userChat = UserChat.fromDocument(doc);
                          if (userChat.id == currentUserId) {
                            return const SizedBox.shrink();
                          } else {
                            return Column(
                              children: [
                                ListTile(
                                  leading: userChat.photoUrl.isNotEmpty
                                      ? Image.network(
                                          userChat.photoUrl,
                                          fit: BoxFit.cover,
                                          width: 50,
                                          height: 50,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            }
                                            return SizedBox(
                                              height: 50,
                                              width: 50,
                                              child: Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                color: Colors.green,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              )),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  const Icon(
                                            Icons.account_circle,
                                            size: 50,
                                          ),
                                        )
                                      : const Icon(Icons.account_circle),
                                  title: Text(
                                    userChat.nickname,
                                    maxLines: 1,
                                  ),
                                  subtitle:
                                      Text("About me: ${userChat.aboutMe}"),
                                  onTap: () {
                                    Navigator.pushNamed(context, ChatPage.route,
                                        arguments: ChatPageArguments(
                                            userChat.id,
                                            userChat.photoUrl,
                                            userChat.nickname));
                                  },
                                ),
                                const Divider()
                              ],
                            );
                          }
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    );
                  } else {
                    return const Center(
                      child: Text("No User"),
                    );
                  }
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ))
          ],
        ));
  }
}
