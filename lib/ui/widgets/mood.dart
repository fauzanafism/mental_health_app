import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class Mood extends StatelessWidget {
  final String moodString;
  final String imageUrl;
  final Color bgColor;
  const Mood({
    Key? key,
    required this.moodString,
    required this.imageUrl,
    required this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 59,
          height: 62,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16), color: bgColor),
          child: Image.asset(imageUrl),
        ),
        const SizedBox(height: 5),
        Text(
          moodString,
          style: kBodyText,
        )
      ],
    );
  }
}
