import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';
import 'package:provider/provider.dart';

import '../../providers/providers.dart';
import '../widgets/widgets.dart';

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late AuthProvider authProvider;
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
  }

  String time() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    } else if (hour < 20) {
      return 'Afternoon';
    } else {
      return 'Night';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good ${time()},',
          style: kHeading5,
        ),
        const SizedBox(height: 5),
        Text(
          "${authProvider.getUserNickname()!.split(' ').first}!",
          style: kHeading5Bold,
        ),
        const SizedBox(height: 30),
        Text(
          'Ada rencana apa untuk hari ini?',
          style: kSubtitle,
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: const [
              Mood(
                moodString: 'Survey',
                imageUrl: 'assets/icons/Happy.png',
                bgColor: Color(0xffEF5DA8),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Ngoding',
                imageUrl: 'assets/icons/Calm - Icon.png',
                bgColor: Color(0xffAEAFF7),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Santai',
                imageUrl: 'assets/icons/Relax.png',
                bgColor: Color(0xffA0E3E2),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Sakit',
                imageUrl: 'assets/icons/Angry.png',
                bgColor: Color(0xffF09E54),
              ),
              SizedBox(width: 22),
              Mood(
                moodString: 'Izin',
                imageUrl: 'assets/icons/Angry.png',
                bgColor: Color(0xffC3F2A6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        const BigBox(
          title: 'Agenda',
          subtitle: 'Rapat DPKPP',
          buttonText: '26 April 2023',
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
            SmallBox(text: 'Catatan', icons: Icons.library_books)
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
          title: 'Libur mendatang',
          subtitle: 'Hari Buruh',
          buttonText: 'Selamat berlibur!',
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
