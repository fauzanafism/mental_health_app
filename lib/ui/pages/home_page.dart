import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

import '../widgets/widgets.dart';

class Home extends StatelessWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good Afternoon,',
          style: kHeading5,
        ),
        const SizedBox(height: 5),
        Text(
          'Fauzan!',
          style: kHeading5Bold,
        ),
        const SizedBox(height: 30),
        Text(
          'How are you feeling today?',
          style: kSubtitle,
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              Mood(
                moodString: 'Happy',
                imageUrl: 'assets/icons/Happy.png',
                bgColor: Color(0xffEF5DA8),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Calm',
                imageUrl: 'assets/icons/Calm - Icon.png',
                bgColor: Color(0xffAEAFF7),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Manic',
                imageUrl: 'assets/icons/Relax.png',
                bgColor: Color(0xffA0E3E2),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Angry',
                imageUrl: 'assets/icons/Angry.png',
                bgColor: Color(0xffF09E54),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Sad',
                imageUrl: 'assets/icons/Angry.png',
                bgColor: Color(0xffC3F2A6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const BigBox(
          title: '1 on 1 Sessions',
          subtitle: '"Let’s open up to the things that matter the most "',
          buttonText: 'Book Now',
          buttonIcon: Icons.calendar_month_outlined,
          isImage: true,
          image: 'assets/images/Meetup.png',
          color: Color(0xffFEF3E7),
          isGrey: true,
        ),
        const SizedBox(height: 30),
        Row(
          children: const [
            SmallBox(
              icons: Icons.book,
              text: 'Journal',
            ),
            SizedBox(width: 15),
            SmallBox(text: 'Library', icons: Icons.library_books)
          ],
        ),
        const SizedBox(height: 15),
        Container(
          decoration: BoxDecoration(
              color: const Color(0xffF4F3F1),
              borderRadius: BorderRadius.circular(16)),
          height: 79,
          padding: const EdgeInsets.all(20),
          child: Row(children: [
            Expanded(
                flex: 5,
                child: Text(
                    '“It is better to conquer yourself than to win a thousand battles”',
                    style: kBodyText.copyWith(
                        fontSize: 14, color: kColorSoftGrey))),
            const SizedBox(width: 5),
            const Expanded(
              flex: 1,
              child: Icon(
                Icons.format_quote,
                color: kColorGrey,
                size: 50,
              ),
            ),
          ]),
        ),
        const SizedBox(height: 30),
        const BigBox(
          title: 'Plan Expired',
          subtitle: 'Get back chat access and session credits',
          buttonText: 'Buy More',
          buttonIcon: Icons.forward,
          isImage: true,
          image: 'assets/images/Meditation.png',
          color: Color(0xff53A06E),
          isGrey: false,
        )
      ],
    );
  }
}
