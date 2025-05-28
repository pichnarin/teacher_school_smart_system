import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pat_asl_portal/ui/screen/authentiation_screen/login.dart';
import 'package:pat_asl_portal/util/theme/app_color.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'School Smart System',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColor.primary,
          secondary: AppColor.secondary,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          foregroundColor: AppColor.primary,
        ),
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: AppColor.secondary.withOpacity(0.2),
          labelTextStyle: WidgetStateProperty.all(
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainScreen());
}
