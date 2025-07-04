import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'package:pat_asl_portal/bloc/class/class_bloc.dart';
import 'package:pat_asl_portal/screen/global_widget/app_life_cycle_manager.dart';
import 'package:pat_asl_portal/screen/navigator/navigator_controller.dart';
import 'package:pat_asl_portal/screen/splash/splash_screen.dart';
import 'package:pat_asl_portal/util/checker/wifi_info.dart';
import 'bloc/auth/auth_bloc.dart';
import 'bloc/auth/auth_event.dart';
import 'bloc/enrollment/enrollment_bloc.dart';
import 'bloc/enrollment/enrollment_event.dart';
import 'bloc/enrollment/enrollment_state.dart';
import 'data/model/attendance_record.dart';
import 'data/model/class_attendance.dart';
import 'data/model/dto/class_attendance_dto.dart';
import 'data/repository/auth/auth_repository.dart';
import 'data/repository/base_repository.dart';
import 'data/repository/class_repository.dart';
import 'data/repository/enrollment_repository.dart';
import 'data/service/auth/auth_service.dart';
import 'data/service/class_service.dart';
import 'data/service/enrollment_service.dart';
import 'data/service/web_socket/web_socket_service.dart';
import 'data/user_local_storage/secure_storage.dart';

// Create a global instance of SecureLocalStorage
final secureLocalStorage = SecureLocalStorage();
final webSocketService = WebSocketService();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await getNetworkInfo();

  try {
    // Initialize dependencies
    final baseRepository = BaseRepository(http.Client(), secureLocalStorage);
    final enrollmentRepository = EnrollmentRepository(baseRepository: baseRepository);
    final enrollmentService = EnrollmentService(repository: enrollmentRepository);

    // Create the Bloc
    final enrollmentBloc = EnrollmentBloc(enrollmentService: enrollmentService);

    // // Stream subscription to listen for state changes
    // final subscription = enrollmentBloc.stream.listen((state) {
    //   print('Current state: ${state.status}');
    //   if (state.status == EnrollmentStatus.attendanceSubmitted) {
    //     print('Attendance successfully submitted!');
    //     print('Attendance records: ${state.attendanceRecords}');
    //   } else if (state.status == EnrollmentStatus.attendanceError) {
    //     print('Error submitting attendance: ${state.errorMessage}');
    //   }
    // });

    // Test data
    final testDate = "2025-07-04"; // Use a valid date format
    final testClassID = '609fc331-b412-4d9c-9a83-9f93505b754d';

    final resulr = enrollmentService.getAttendanceByClassAndDate(classId: testClassID, date: testDate);

    print(resulr);

    // // Create test attendance records
    // final attendanceRecords = [
    //   AttendanceRecord(studentId: "2b33561f-d021-43d8-bc2b-968972fb87de", status: "present"),
    //   AttendanceRecord(studentId: "f6c62ef1-68c3-406d-97fe-78784e00ea5e", status: "absent"),
    //   AttendanceRecord(studentId: "756daba4-add6-4d54-b0af-3496c8370c59", status: "present"),
    //   AttendanceRecord(studentId: "99438ce6-7e1a-4e67-8fd8-4e8a4cbfe3f8", status: "absent"),
    // ];

    // // Create ClassAttendanceDTO directly
    // final attendanceDTO = ClassAttendanceDTO(
    //   classId: testClassID,
    //   date: testDate,
    //   attendanceRecords: attendanceRecords,
    // );

    // // First, load the enrollments for the class to populate the bloc state
    // enrollmentBloc.add(FetchEnrollmentsByClassId(testClassID));
    //
    // // Wait a bit to ensure the fetch completes
    // await Future.delayed(const Duration(seconds: 2));
    //
    // // Now dispatch the MarkAttendance event
    // enrollmentBloc.add(MarkAttendance(attendanceDTO));
    //
    // // Wait to see the result
    // await Future.delayed(const Duration(seconds: 3));
    //
    // // Clean up
    // await subscription.cancel();

  } catch(e) {
    print('Error in test: $e');
  }

  // 28539131-2ac2-4ddd-a256-86e6e7d90af2

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

          // EnrollmentBloc to handle enrollment data
          BlocProvider(
            create: (context) => EnrollmentBloc(
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
