import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class DetailedStatistics extends StatelessWidget {
  const DetailedStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    return Column(
      children: [],
    );
  } //TODO add some stats
}
