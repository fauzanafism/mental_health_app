import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class SmallBox extends StatelessWidget {
  final String text;
  final IconData icons;

  const SmallBox({
    Key? key,
    required this.text,
    required this.icons,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16), color: kColor2x1),
        width: MediaQuery.of(context).size.width / 3,
        height: 62,
        child: Row(
          children: [
            Icon(
              icons,
              color: kColorIconGrey,
            ),
            const SizedBox(width: 10),
            Text(
              text,
              style: kBodyText.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                  color: kColorBrown),
            )
          ],
        ),
      ),
    );
  }
}
