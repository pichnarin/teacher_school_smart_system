import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_event.dart';
import 'package:pat_asl_portal/bloc/class_session/class_session_state.dart';
import 'package:pat_asl_portal/data/service/class_session_service.dart';

class ClassSessionBloc extends Bloc<ClassSessionEvent, ClassSessionState> {
  final ClassSessionService _classService;

  ClassSessionBloc({
    required ClassSessionService classService,
  })  : _classService = classService,
        super(const ClassSessionState()) {
    on<FetchClassSessions>(_onFetchSessionClass);
    on<FetchClassSessionsByDate>(_onFetchClassSessionByDate);
    on<FetchClassSessionById>(_onFetchClassSessionById);

  }


  // Fetch all classes
  void _onFetchSessionClass(
      FetchClassSessions event,
      Emitter<ClassSessionState> emit,
      ) async {
    emit(state.copyWith(status: ClassSessionStatus.loading));

    try {
      final classSessions = await _classService.getAllAssignedClassSessions();

      emit(state.copyWith(
        status: ClassSessionStatus.loaded,
        classes: classSessions,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // Fetch classes by date example 2023-10-01
  void _onFetchClassSessionByDate(
      FetchClassSessionsByDate event,
      Emitter<ClassSessionState> emit,
      ) async {
    emit(state.copyWith(status: ClassSessionStatus.loading));

    try {
      final classSessions = await _classService.getClasseSessionByDate(event.date);
      // debugPrint("Classes for date ${event.date}: $classes");

      emit(state.copyWith(
        status: ClassSessionStatus.loaded,
        classFilterByDate: classSessions,
        selectedDate: event.date,
      ));
    } catch (e) {
      // debugPrint("Error fetching classes by date: $e");
      emit(state.copyWith(
        status: ClassSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

//uuid
  void _onFetchClassSessionById(
      FetchClassSessionById event,
      Emitter<ClassSessionState> emit,
      ) async {
    emit(state.copyWith(status: ClassSessionStatus.loading));
    try {
      final classSessions = await _classService.getClassSessionByID(event.classId);

      // Expecting exactly 1 session:
      final classSession = classSessions.isNotEmpty ? classSessions.first : null;

      emit(state.copyWith(
        status: ClassSessionStatus.loaded,
        classFilterById: classSession,
        classId: event.classId,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassSessionStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

}

