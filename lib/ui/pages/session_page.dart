import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

import 'package:mental_health_app/ui/widgets/widgets.dart';

class Session extends StatelessWidget {
  const Session({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const BigBox(
            title: 'Upcoming Session',
            subtitle:
                'Sahana V, M.Sc in Clinical Psychology\n\n7:30 PM - 8:30 PM',
            buttonText: 'Join Now',
            buttonIcon: Icons.play_circle,
            color: Color(0xffFEF3E7),
            isGrey: true,
            isImage: false),
        const SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(
                  'All Sessions',
                  style: kSubtitle.copyWith(
                      fontSize: 18, color: const Color(0xff371B34)),
                ),
                const Icon(Icons.arrow_drop_down_outlined)
              ],
            ),
            const Icon(
              Icons.sort,
              color: kColorGrey,
            )
          ],
        ),
        const SizedBox(height: 30),
        const SessionWidget(
          firstButtonString: 'Reschedule',
          secondButtonString: 'Join Now',
        ),
        const SizedBox(height: 15),
        const SessionWidget(
            firstButtonString: 'Re-book', secondButtonString: 'View Profile')
      ],
    );
  }
}
