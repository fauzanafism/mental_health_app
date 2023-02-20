import 'package:flutter/material.dart';
import 'package:mental_health_app/common/constant.dart';

class ChipActive extends StatelessWidget {
  final String label;
  const ChipActive({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kColorOrange, borderRadius: BorderRadius.circular(9)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Text(
        label,
        style: kSubtitle.copyWith(fontSize: 14, color: Colors.white),
      ),
    );
  }
}

class ChipInactive extends StatelessWidget {
  final String label;
  const ChipInactive({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: kColor2x1, borderRadius: BorderRadius.circular(9)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
      child: Text(
        label,
        style: kSubtitle.copyWith(fontSize: 14, color: const Color(0xff8A8A8A)),
      ),
    );
  }
}
