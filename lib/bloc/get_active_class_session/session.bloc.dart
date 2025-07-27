import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pat_asl_portal/bloc/get_active_class_session/session_event.dart';
import 'package:pat_asl_portal/bloc/get_active_class_session/session_state.dart';

import 'package:pat_asl_portal/data/model/dto/class_session_dto.dart';
import 'package:pat_asl_portal/data/service/session_service.dart';
import 'package:pat_asl_portal/util/exception/api_exception.dart';


class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionService _sessionService;

  SessionBloc({required SessionService sessionService})
      : _sessionService = sessionService,
        super(SessionInitial()) {
    on<FetchActiveSession>(_onFetchActiveSession);
  }

  Future<void> _onFetchActiveSession(
      FetchActiveSession event,
      Emitter<SessionState> emit,
      ) async {
    emit(SessionLoading());
    try {
      final session = await _sessionService.getActiveSession(event.classId, event.sessionDate, event.startTime, event.endTime);
      emit(SessionLoaded(session));
    } on ApiException catch (e) {
      emit(SessionError(e.message));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }
}
