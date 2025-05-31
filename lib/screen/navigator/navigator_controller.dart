import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:flutter/material.dart';
import '../home/home_screen.dart';

class NavigatorController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    Container(color: Colors.green),
    Container(color: Colors.orange),
    Container(color: Colors.purple),
    Container(color: Colors.blue),
  ];
}