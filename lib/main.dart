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

  // try{
  //   final baseRepository = BaseRepository(http.Client(), secureLocalStorage);
  //   final repo = EnrollmentRepository(baseRepository: baseRepository);
  //   final service = EnrollmentService(repository: repo);
  //   // final bloc = ClassBloc(classService: service);
  //
  //   final String classId = "99943cf4-8567-47a2-ba8e-5f48a663c3e3";
  //
  //   final get = await service.getEnrollmentsByClassId(classId);
  //
  //   debugPrint('Enrollment Count: ${get.toString()}');
  //
  //   // final String month = "1";
  //   // final String year = "2025";
  //
  //   // final subscription = bloc.stream.listen((state) {
  //   //   debugPrint('Bloc State: $state');
  //   //   debugPrint('Student Report: ${state.studentReports}');
  //   // });
  //   //
  //   // await Future.delayed(const Duration(seconds: 2));
  //   //
  //   // bloc.add(FetchStudentReport(
  //   //   classId: classId,
  //   //   reportMonth: month,
  //   //   reportYear: year,
  //   // ));
  //
  //
  // }catch(error){
  //   debugPrint('Stacktrace: $error');
  // }

  // try {
  //   final baseRepository = BaseRepository(http.Client(), secureLocalStorage);
  //   final repo = DailyEvaluationRepository(baseRepository: baseRepository);
  //   final service = DailyEvaluationService(dailyEvaluationRepository: repo);
  //   final bloc = DailyEvaluationBloc(service);
  //
  //   final subscription = bloc.stream.listen((state) {
  //     debugPrint('Bloc State: $state');
  //   });
  //
  //   bloc.add(CheckDailyEvaluationExist("0b8c71c5-4998-47d1-8351-c5df5c259ae5"));
  //
  //   final payload = [
  //     DailyEvaluationCreateDTO(
  //       studentId: "f0056ec4-0cca-4002-98ba-4870ce9847c2",
  //       homework: "perfect",
  //       clothing: "perfect",
  //       attitude: "perfect",
  //       classActivity: 9,
  //     ),
  //     DailyEvaluationCreateDTO(
  //       studentId: "7d5c80e5-dc68-4dd3-9c66-d8e80b6685ab",
  //       homework: "good",
  //       clothing: "average",
  //       attitude: "good",
  //       classActivity: 7,
  //     ),
  //     DailyEvaluationCreateDTO(
  //       studentId: "7912d7d3-9765-4735-bcc9-8d24c1509264",
  //       homework: "good",
  //       clothing: "average",
  //       attitude: "good",
  //       classActivity: 7,
  //     ),
  //     DailyEvaluationCreateDTO(
  //       studentId: "37d7e35e-e3c7-418a-8b14-a4e9914544a2",
  //       homework: "good",
  //       clothing: "average",
  //       attitude: "good",
  //       classActivity: 7,
  //     ),
  //     DailyEvaluationCreateDTO(
  //       studentId: "ea503117-cd20-475d-b7b8-063cf6d0027c",
  //       homework: "good",
  //       clothing: "average",
  //       attitude: "good",
  //       classActivity: 7,
  //     ),
  //   ];
  //
  //   bloc.add(CreateDailyEvaluations("0b8c71c5-4998-47d1-8351-c5df5c259ae5", payload));
  //
  //   bloc.add(FetchDailyEvaluations("99de050d-b4e2-4eea-8051-b6e895ab7f23", "2025-07-19"));
  //
  //   final patchPayload = [
  //     DailyEvaluationPatch(
  //       id: "7bd4d1f9-1402-480a-a865-225e89c2b2b0",
  //       homework: "average",
  //       clothing: "average",
  //       attitude: "average",
  //       classActivity: 9,
  //     ),
  //     DailyEvaluationPatch(
  //       id: "4571897f-7fbc-4b4a-983a-d61f53929d70",
  //       homework: "average",
  //       clothing: "average",
  //       attitude: "average",
  //       classActivity: 8,
  //     ),
  //     DailyEvaluationPatch(
  //       id: "c0ac0cdd-f300-4b6c-9fd2-45c9edf18b19",
  //       homework: "average",
  //       clothing: "average",
  //       attitude: "average",
  //       classActivity: 8,
  //     ),
  //     DailyEvaluationPatch(
  //       id: "8c1e59cf-72fd-40d0-9371-4b9f2c2e9f15",
  //       homework: "average",
  //       clothing: "average",
  //       attitude: "average",
  //       classActivity: 8,
  //     ),
  //     DailyEvaluationPatch(
  //       id: "357ea9d7-9d8d-49f5-a58f-17396930c5f4",
  //       homework: "average",
  //       clothing: "average",
  //       attitude: "average",
  //       classActivity: 8,
  //     )
  //   ];
  //
  //   final patchPayloadMap = patchPayload.map((e) => e.toJson()).toList();
  //   bloc.add(PatchDailyEvaluations(patchPayloadMap));
  //
  //   bloc.add(FetchDailyEvaluations("99de050d-b4e2-4eea-8051-b6e895ab7f23", "2025-07-19"));
  //
  // } catch (e) {
  //   debugPrint('Error fetching classes: $e');
  // }

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
