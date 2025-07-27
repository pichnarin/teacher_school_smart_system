import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/navigator/tab_navigator.dart';
import 'package:pat_asl_portal/screen/profile/profile_screen.dart';
import 'package:pat_asl_portal/screen/record/record_screen.dart';
import 'package:pat_asl_portal/screen/schedule/schedule_screen.dart';
import '../home/home_screen.dart';

class NavigatorController extends GetxController {
  final selectedIndex = 0.obs;

  final List<GlobalKey<NavigatorState>> navigatorKeys = List.generate(
    5,
    (index) => GlobalKey<NavigatorState>(),
  );

  void pushToCurrentTab(Widget screen) {
    navigatorKeys[selectedIndex.value]
        .currentState
        ?.push(MaterialPageRoute(builder: (_) => screen));
  }

  final List<Widget> screens = [
    TabNavigator(index: 0, child: HomeScreen()),
    TabNavigator(index: 1, child: RecordScreen()),
    TabNavigator(index: 2, child: ScheduleScreen()),
    TabNavigator(index: 3, child: Container(color: Colors.purple)),
    TabNavigator(index: 4, child: ProfileScreen()),
  ];
}