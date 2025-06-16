import 'package:flutter/material.dart';
import 'package:pat_asl_portal/screen/global_widget/header.dart';

class BaseScreen extends StatelessWidget {
  final Widget body;

  const BaseScreen({
    super.key,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(
        logoPath: 'assets/logo.png',
        onNotificationPressed: () {
          // Handle notification click
          print('Notification clicked');
        },
      ),
      body: body,
    );
  }
}