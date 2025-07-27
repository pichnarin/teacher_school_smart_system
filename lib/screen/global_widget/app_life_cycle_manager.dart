import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/class_session/class_session_bloc.dart';
import '../../bloc/class_session/class_session_event.dart';
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
      final classBloc = BlocProvider.of<ClassSessionBloc>(context);
      classBloc.add(const FetchClassSessions());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}