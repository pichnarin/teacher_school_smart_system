import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigator_controller.dart';

class TabNavigator extends StatelessWidget {
  final int index;
  final Widget child;

  const TabNavigator({super.key, required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NavigatorController>();
    return Navigator(
      key: controller.navigatorKeys[index],
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (_) => child,
        );
      },
    );
  }
}
