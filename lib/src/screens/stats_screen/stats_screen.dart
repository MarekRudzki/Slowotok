import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import '../../services/constants.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});
//TODO add stats charts
  @override
  Widget build(BuildContext context) {
    final statsBox = Hive.box('statsBox');

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Statystyki'),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Constants.gradientBackgroundLighter,
                Constants.gradientBackgroundDarker,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Container(),
        ),
      ),
    );
  }
}
