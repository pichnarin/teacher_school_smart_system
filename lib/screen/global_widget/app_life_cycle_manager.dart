import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/class/class_bloc.dart';
import '../../bloc/class/class_event.dart';
import '../../main.dart';

class AppLifecycleManager extends StatefulWidget {
  final Widget child;

  const AppLifecycleManager({super.key, required this.child});

  @override
  AppLifecycleManagerState createState() => AppLifecycleManagerState();
}

class AppLifecycleManagerState extends State<AppLifecycleManager> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Reconnect WebSocket and refresh data
      webSocketService.handleAppResume();
      // Refresh current classes
      final classBloc = BlocProvider.of<ClassBloc>(context);
      classBloc.add(const FetchClasses());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}