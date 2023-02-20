import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class PostWidget extends StatelessWidget {
  final String imageUrl;
  final String username;
  final String timePosted;
  final String likeCount;
  final String commentCount;
  const PostWidget({
    Key? key,
    required this.imageUrl,
    required this.username,
    required this.timePosted,
    required this.likeCount,
    required this.commentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(backgroundImage: AssetImage(imageUrl)),
      title: Row(
        children: [
          Text(
            username,
            style: kBodyTextRubik.copyWith(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
          Text(
            '• $timePosted',
            style: kBodyTextRubik.copyWith(color: kColorSoftGrey),
          )
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 15),
            child: Text(
              'Is there a therapy which can cure inner child?',
              style: kBodyTextRubik.copyWith(fontSize: 13, color: kColorBrown),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.thumb_up, color: kColorGrey),
                  const SizedBox(width: 4),
                  Text(
                    likeCount,
                    style: kBodyTextRubik.copyWith(
                        fontSize: 13, color: kColorSoftGrey),
                  ),
                  const SizedBox(width: 15),
                  const Icon(Icons.comment, color: kColorGrey),
                  const SizedBox(width: 4),
                  Text(
                    commentCount,
                    style: kBodyTextRubik.copyWith(
                        fontSize: 13, color: kColorSoftGrey),
                  )
                ],
              ),
              const Icon(Icons.share, color: kColorGrey)
            ],
          )
        ],
      ),
    );
  }
}
