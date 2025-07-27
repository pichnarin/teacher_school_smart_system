import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/bloc/class/class_state.dart';
import 'package:pat_asl_portal/data/service/class_service.dart';


class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService _classService;

  ClassBloc({
    required ClassService classService,
  })  : _classService = classService,
        super(const ClassState()) {
    on<FetchClasses>(_onFetchClasses);
    on<FetchClassByDate>(_onFetchClassByDate);
    on<FetchClassById>(_onFetchClassById);
    on<FetchStudentReport>(_onFetchStudentReport);
  }


  // Fetch all classes
  void _onFetchClasses(
      FetchClasses event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));

    try {
      final classes = await _classService.fetchAllClasses();

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classes: classes,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // Fetch classes by date example 2023-10-01
  void _onFetchClassByDate(
      FetchClassByDate event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));

    try {
      final classes = await _classService.fetchClassByDate(event.date);

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classFilterByDate: classes,
        selectedDate: event.date,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

//uuid
  void _onFetchClassById(
      FetchClassById event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final classes = await _classService.fetchClassById(event.classId);

      final classSession = classes.isNotEmpty ? classes.first : null;

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classFilterById: classSession,
        classId: event.classId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onFetchStudentReport(
      FetchStudentReport event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));
    try {
      final studentReports = await _classService.fetchStudentReport(
        event.classId,
        event.reportMonth,
        event.reportYear,
      );

      emit(state.copyWith(
        status: ClassStatus.loaded,
        studentReports: studentReports,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

}

