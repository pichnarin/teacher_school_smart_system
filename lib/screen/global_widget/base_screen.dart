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
        logoPath: 'assets/design_properties/ang_soeng_logo.jpg',
        onNotificationPressed: () {
          // Handle notification click

        },
      ),
      body: body,
    );
  }
}