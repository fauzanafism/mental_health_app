import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:mental_health_app/ui/widgets/widgets.dart';

class WellnessPage extends StatelessWidget {
  const WellnessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 6 / 8 + 10,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Wellness Hub',
                  style: kSubtitle.copyWith(fontSize: 18),
                ),
                const SizedBox(height: 20),
                const SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ChipActive(
                        label: 'Trending',
                      ),
                      SizedBox(width: 12),
                      ChipInactive(label: 'Relationship'),
                      SizedBox(width: 12),
                      ChipInactive(label: 'Self Care'),
                      SizedBox(width: 12),
                      ChipInactive(label: 'Healing')
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                const PostWidget(
                  imageUrl: 'assets/images/pp-basic.png',
                  username: 'Coal Dingo ',
                  timePosted: 'just now',
                  likeCount: '2',
                  commentCount: '',
                ),
                const Divider(),
                const PostWidget(
                  imageUrl: 'assets/images/pp-topi.png',
                  username: 'Pigeon Car ',
                  timePosted: '3 min ago',
                  commentCount: '2',
                  likeCount: '12',
                ),
                const Divider(),
                const PostWidget(
                  imageUrl: 'assets/images/pp-basic.png',
                  username: 'Water Turtle ',
                  timePosted: '30 min ago',
                  likeCount: '8',
                  commentCount: '1',
                ),
                const Divider(),
                const PostWidget(
                  imageUrl: 'assets/images/pp-topi.png',
                  username: 'Flying Lizard ',
                  timePosted: '2 hrs ago',
                  likeCount: '4',
                  commentCount: '',
                ),
                const Divider(),
                const PostWidget(
                  imageUrl: 'assets/images/pp-basic.png',
                  username: 'Iron Fist ',
                  timePosted: '3 hrs ago',
                  likeCount: '2',
                  commentCount: '1',
                )
              ],
            ),
          ),
          Positioned(
            bottom: 1,
            right: 1,
            child: FloatingActionButton(
              backgroundColor: kColorOrange,
              onPressed: () {},
              child: const Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }
}
