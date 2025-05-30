import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/screen/login/login_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'data/repository/auth_repository.dart';
import 'data/service/auth_service.dart';
import 'data/user_local_storage/secure_storage.dart';

// class MainScreen extends StatelessWidget {
//   const MainScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'School Smart System',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(
//           seedColor: AppColor.primary,
//           secondary: AppColor.secondary,
//         ),
//         useMaterial3: true,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           centerTitle: true,
//           foregroundColor: AppColor.primary,
//         ),
//         navigationBarTheme: NavigationBarThemeData(
//           indicatorColor: AppColor.secondary.withOpacity(0.2),
//           labelTextStyle: WidgetStateProperty.all(
//             const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
//           ),
//         ),
//       ),
//       // home: const NavigatorMenu(),
//       home: const LoginScreen(),
//     );
//   }
// }
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const MainScreen());
// }


void main() {
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