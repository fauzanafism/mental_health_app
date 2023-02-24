import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 6 / 8 + 10,
      child: Stack(
        children: [
          Column(
            children: const [
              ChatList(
                imageUrl: 'assets/images/pp-topi.png',
                message: 'Hello there!',
                time: 'just now',
                username: 'Flying Gecko',
              ),
              ChatList(
                imageUrl: 'assets/images/pp-basic.png',
                message: 'Struggling!',
                time: '2 min ago',
                username: 'Green Swamp',
              ),
            ],
          ),
          Positioned(
              bottom: 1,
              right: 1,
              child: FloatingActionButton(
                onPressed: () {},
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
  const ChatList({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.message,
    required this.time,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(backgroundImage: AssetImage(imageUrl)),
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
                const Icon(Icons.check_sharp),
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
