import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mental_health_app/common/constant.dart';

class SessionWidget extends StatelessWidget {
  final String firstButtonString;
  final String secondButtonString;
  const SessionWidget({
    Key? key,
    required this.firstButtonString,
    required this.secondButtonString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 171.h,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: const Color(0xffFEF3E7),
          borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundImage: AssetImage('assets/images/pp.jpeg'),
              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sahana V',
                      style: kBodyTextRubik.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: kColorBrown),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'M.Sc in Clinical Psychology',
                      style: kBodyTextRubik.copyWith(
                          fontWeight: FontWeight.normal),
                    )
                  ],
                ),
              )
            ],
          ),
          const Divider(
            color: Color(0xffD9D8D8),
          ),
          Row(
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: kColorIconGrey,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    "31st March '22",
                    style: kBodyTextRubik.copyWith(color: kColorSoftGrey),
                  ),
                ],
              ),
              const SizedBox(width: 15),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    color: kColorIconGrey,
                    size: 17,
                  ),
                  const SizedBox(width: 5),
                  Text("7:30 PM - 8:30 PM",
                      style: kBodyTextRubik.copyWith(color: kColorSoftGrey)),
                ],
              )
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kColorOrange,
                    borderRadius: BorderRadius.circular(9)),
                height: 35,
                width: 115,
                // padding: const EdgeInsets.all(11),
                child: Center(
                  child: Text(
                    firstButtonString,
                    style:
                        kSubtitle.copyWith(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              const SizedBox(width: 35),
              Text(
                secondButtonString,
                style: kSubtitle.copyWith(color: kColorOrange, fontSize: 14),
              )
            ],
          )
        ],
      ),
    );
  }
}
