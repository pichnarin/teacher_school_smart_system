import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pat_asl_portal/screen/login/login_screen.dart';
import 'package:pat_asl_portal/screen/navigator/navigator_controller.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'data/repository/auth_repository.dart';
import 'data/service/auth_service.dart';
import 'data/user_local_storage/secure_storage.dart';




void main() {
  //register navigator controller
  Get.put(NavigatorController());
  // Initialize secure local storage
  // WidgetsFlutterBinding.ensureInitialized();
  // secureLocalStorage.init();
  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: AuthService(
              repository: AuthRepository(),
              storage: secureLocalStorage,
            ),
          )..add(AuthCheckRequested()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'PAT ASL Portal',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        // home: const NavigatorMenu(),
        home: const LoginScreen()
      ),
    );
  }
}