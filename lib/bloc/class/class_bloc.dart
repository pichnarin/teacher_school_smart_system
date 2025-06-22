import 'dart:async';
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
    on<ClassesUpdatedFromSocket>(_onClassesUpdatedFromSocket);

    // Listen to WebSocket updates
    _setupWebSocketListener();
  }

  void _setupWebSocketListener() {
    _classesSubscription = _webSocketService.classesStream.listen(
          (classes) {
        add(ClassesUpdatedFromSocket(classes));
      },
      onError: (error) {
        emit(state.copyWith(
          status: ClassStatus.error,
          errorMessage: 'WebSocket error: $error',
        ));
      },
    );
  }

  void _onFetchClass(
      FetchClasses event,
      Emitter<ClassState> emit,
      ) async {
    emit(state.copyWith(status: ClassStatus.loading));

    try {
      final classes = await _classService.getAllAssignedClasses();

      emit(state.copyWith(
        status: ClassStatus.loaded,
        classes: List.from(classes),
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ClassStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void _onClassesUpdatedFromSocket(ClassesUpdatedFromSocket event, Emitter<ClassState> emit) {

    emit(state.copyWith(
      status: ClassStatus.loaded,
      classes: List<Class>.from(event.classes),
    ));
  }


  @override
  Future<void> close() {
    _classesSubscription?.cancel();
    return super.close();
  }
}

