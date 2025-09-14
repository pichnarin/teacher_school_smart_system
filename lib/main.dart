import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_bloc.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_event.dart';
import 'package:pat_asl_portal/bloc/daily_evaluation/daily_evaluation_bloc.dart';
import 'package:pat_asl_portal/bloc/enrollment/enrollment_event.dart';
import 'package:pat_asl_portal/data/repository/daily_evaluation_repository.dart';
import 'package:pat_asl_portal/data/repository/exam_record_repository.dart';
import 'package:pat_asl_portal/data/service/daily_evaluation_service.dart';
import 'package:pat_asl_portal/data/service/session_service.dart';
import 'package:pat_asl_portal/screen/global_widget/app_life_cycle_manager.dart';
import 'package:pat_asl_portal/screen/navigator/navigator_controller.dart';
import 'package:pat_asl_portal/screen/splash/splash_screen.dart';
import 'package:pat_asl_portal/util/checker/wifi_info.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/class/class_event.dart';
import 'bloc/class_session/class_session_state.dart';
import 'bloc/daily_evaluation/daily_evaluation_event.dart';
import 'bloc/enrollment/enrollment_bloc.dart';
import 'bloc/exam_record/exam_record_bloc.dart';
import 'bloc/exam_record/exam_record_event.dart';
import 'bloc/get_active_class_session/session.bloc.dart';
import 'data/model/dto/daily_evaluation_dto.dart';
import 'data/repository/auth/auth_repository.dart';
import 'data/repository/base_repository.dart';
import 'data/repository/class_repository.dart';
import 'data/repository/class_session_repository.dart';
import 'data/repository/enrollment_repository.dart';
import 'data/repository/session_repository.dart';
import 'data/service/auth/auth_service.dart';
import 'data/service/class_service.dart';
import 'data/service/class_session_service.dart';
import 'data/service/enrollment_service.dart';
import 'data/service/exam_record_service.dart';
import 'data/service/web_socket/web_socket_service.dart';
import 'data/user_local_storage/secure_storage.dart';

// Create a global instance of SecureLocalStorage
final secureLocalStorage = SecureLocalStorage();
final webSocketService = WebSocketService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await getNetworkInfo();
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
                (context) => ClassSessionBloc(
                  classSessionService: ClassSessionService(
                    repository: ClassSessionRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                ),
          ),

          // EnrollmentBloc to handle enrollment data
          BlocProvider(
            create:
                (context) => EnrollmentBloc(
                  enrollmentService: EnrollmentService(
                    repository: EnrollmentRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                ),
          ),

          //RecordBloc to handle record data
          BlocProvider(
            create:
                (context) => ExamRecordBloc(
                  recordService: ExamRecordService(
                    repository: ExamRecordRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                ),
          ),

          // SessionBloc to manage class sessions
          BlocProvider(
            create:
                (context) => SessionBloc(
                  sessionService: SessionService(
                    sessionRepository: SessionRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                ),
          ),

          // ClassBloc to manage class data
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
                )..add(const FetchClasses()),
          ),
          // DailyEvaluationBloc to manage daily evaluations
          BlocProvider(
            create:
                (context) => DailyEvaluationBloc(
                  service: DailyEvaluationService(
                    dailyEvaluationRepository: DailyEvaluationRepository(
                      baseRepository: BaseRepository(
                        http.Client(),
                        secureLocalStorage,
                      ),
                    ),
                  ),
                ),
          ),
        ],
        child: AppLifecycleManager(
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
      ),
    );
  }
}
