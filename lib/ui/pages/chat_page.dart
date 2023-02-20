import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
                backgroundImage: AssetImage('assets/images/pp.jpeg')),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Fauzan Nafis M',
                  style: kBodyTextRubik.copyWith(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Just now',
                  style: kBodyTextRubik.copyWith(color: kColorSoftGrey),
                )
              ],
            ),
            subtitle: Row(
              children: [
                const Icon(Icons.check_sharp),
                const SizedBox(width: 5),
                Text(
                  'Is there a therapy which can cure inner child?',
                  overflow: TextOverflow.ellipsis,
                  style:
                      kBodyTextRubik.copyWith(fontSize: 13, color: kColorBrown),
                ),
              ],
            ),
          ),
          const Divider()
        ],
      ),
    );
  }
}
