import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'navigator_controller.dart';



class NavigatorMenu extends StatelessWidget {
  const NavigatorMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigatorController());

    return Obx(() {
      return WillPopScope(
        onWillPop: () async {
          final canPop = controller
              .navigatorKeys[controller.selectedIndex.value]
              .currentState!
              .canPop();
          if (canPop) {
            controller
                .navigatorKeys[controller.selectedIndex.value]
                .currentState!
                .pop();
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: Obx(() => IndexedStack(
            index: controller.selectedIndex.value,
            children: controller.screens,
          )),

          bottomNavigationBar: NavigationBar(
            height: 80,
            elevation: 0,
            selectedIndex: controller.selectedIndex.value,
            onDestinationSelected: (index) =>
            controller.selectedIndex.value = index,
            destinations: const [
              NavigationDestination(
                  icon: Icon(Icons.home_outlined), label: 'ផ្ទះ'),
              NavigationDestination(
                  icon: Icon(Icons.account_tree_outlined), label: 'កំណត់ត្រា'),
              NavigationDestination(
                  icon: Icon(Icons.schedule_outlined), label: 'កាលបរិច្ឆេទ'),
              NavigationDestination(
                  icon: Icon(Icons.chat_outlined), label: 'សារប្រតិបត្តិការ'),
              NavigationDestination(
                  icon: Icon(Icons.person_outline), label: 'គណនី'),
            ],
          ),
        ),
      );
    });
  }
}

