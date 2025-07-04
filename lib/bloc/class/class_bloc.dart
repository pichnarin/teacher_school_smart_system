import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pat_asl_portal/bloc/class/class_event.dart';
import 'package:pat_asl_portal/bloc/class/class_state.dart';
import 'package:pat_asl_portal/data/model/class.dart';
import 'package:pat_asl_portal/data/service/class_service.dart';
import '../../data/service/web_socket/web_socket_service.dart';

class ClassBloc extends Bloc<ClassEvent, ClassState> {
  final ClassService _classService;
  final WebSocketService _webSocketService;
  StreamSubscription? _classesSubscription;

  ClassBloc({
    required ClassService classService,
    required WebSocketService webSocketService,
  })  : _classService = classService,
        _webSocketService = webSocketService,
        super(const ClassState()) {
    on<FetchClasses>(_onFetchClass);
    on<FetchClassesByDate>(_onFetchClassesByDate);
    on<FetchClassById>(_onFetchClassById);
    on<UpdateClassesFromWebSocket>(_onUpdateClassesFromWebSocket);

    // Listen to WebSocket updates
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    _classesSubscription = _webSocketService.classesStream.listen(
          (classes) {
        add(UpdateClassesFromWebSocket(classes));
      },
      onError: (error) {
        emit(state.copyWith(
          status: ClassStatus.error,
          errorMessage: 'WebSocket error: $error',
        ));
      },
    );
  }

  void _onUpdateClassesFromWebSocket(
      UpdateClassesFromWebSocket event,
      Emitter<ClassState> emit,
      ) {
    final updatedClasses = List<Class>.from(event.classes);

    // Create updated state with main classes list
    ClassState updatedState = state.copyWith(
      status: ClassStatus.loaded,
      classes: updatedClasses,
    );

    // If we have a selected date, also filter classes for that date
    if (state.selectedDate != null) {
      final dateToCompare = state.selectedDate!;

      final filteredClasses = updatedClasses
          .where((cls) {
        // Convert DateTime to string in YYYY-MM-DD format for comparison
        final classDate = "${cls.schedule.date.year}-"
            "${cls.schedule.date.month.toString().padLeft(2, '0')}-"
            "${cls.schedule.date.day.toString().padLeft(2, '0')}";

        return classDate == dateToCompare;
      })
          .toList();

      updatedState = updatedState.copyWith(
          classFilterByDate: filteredClasses
      );
    }

    emit(updatedState);
  }

  // Fetch all classes
  void _onFetchClass(
      FetchClasses event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));

    try {
      final classes = await _classService.getAllAssignedClasses();
      // debugPrint("classes: $classes");

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classes: List.from(classes),
      ));
    } catch (e) {
      // debugPrint("Error fetching classes: $e");
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // Fetch classes by date example 2023-10-01
  void _onFetchClassesByDate(
      FetchClassesByDate event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));

    try {
      final classes = await _classService.getClassesByDate(event.date);
      // debugPrint("Classes for date ${event.date}: $classes");

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classFilterByDate: List.from(classes),
        selectedDate: event.date,
      ));
    } catch (e) {
      // debugPrint("Error fetching classes by date: $e");
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
      final classItem = await _classService.getClassByID(event.classId);
      // debugPrint("Class for ID ${event.classId}: $classItem");

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classFilterById: List.from([classItem]),
        classId: event.classId,
      ));
    } catch (e) {
      // debugPrint("Error fetching class by ID: $e");
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }




  @override
  Future<void> close() {
    _classesSubscription?.cancel();
    return super.close();
  }
}

