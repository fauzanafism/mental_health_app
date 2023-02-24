import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health_app/common/constant.dart';

class BigBox extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final IconData buttonIcon;
  final String? image;
  final Color color;
  final bool isGrey;
  final bool isImage;

  const BigBox({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.buttonIcon,
    this.image,
    required this.color,
    required this.isGrey,
    required this.isImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(16)),
      height: 151.h,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style:
                        isGrey ? kTitle : kTitle.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    subtitle,
                    style: isGrey
                        ? kBodyTextRubik
                        : kBodyTextRubik.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Text(
                        buttonText,
                        style: isGrey
                            ? kButton
                            : kButton.copyWith(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      Icon(
                        buttonIcon,
                        color: isGrey ? kColorOrange : Colors.white,
                        size: 17,
                      )
                    ],
                  )
                ],
              ),
            ),
            isImage
                ? Expanded(flex: 1, child: Image.asset(image!))
                : Container()
          ],
        ),
      ),
    );
  }
}
