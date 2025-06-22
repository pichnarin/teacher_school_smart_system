import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/screen/navigator/navigator_controller.dart';
import 'package:pat_asl_portal/screen/splash/splash_screen.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'data/repository/auth/auth_repository.dart';
import 'data/repository/base_repository.dart';
import 'data/repository/class_repository.dart';
import 'data/service/auth/auth_service.dart';
import 'data/service/class_service.dart';
import 'data/service/web_socket/web_socket_service.dart';
import 'data/user_local_storage/secure_storage.dart';

// Create a global instance of SecureLocalStorage
final secureLocalStorage = SecureLocalStorage();
final webSocketService = WebSocketService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the WebSocketService with token if available
  final token = await secureLocalStorage.retrieveToken();
  if (token != null) {
    webSocketService.initialize(token);
  }

  // Register navigator controller
  Get.put(NavigatorController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [RepositoryProvider(create: (_) => webSocketService)],
      child: MultiBlocProvider(
        providers: [
          // AuthBloc to handle authentication state
          BlocProvider(
            create:
                (context) => AuthBloc(
                  authService: AuthService(
                    repository: AuthRepository(),
                    storage: secureLocalStorage,
                  ),
                )..add(AuthCheckRequested()),
          ),

          // ClassBloc to include WebSocketService
          BlocProvider(
            create:
                (context) => ClassBloc(
                  classService: ClassService(
                    repository: ClassRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                  webSocketService: webSocketService,
                ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'PAT ASL Portal',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
