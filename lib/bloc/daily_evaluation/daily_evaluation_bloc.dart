import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/service/daily_evaluation_service.dart';
import 'daily_evaluation_event.dart';
import 'daily_evaluation_state.dart';

class DailyEvaluationBloc
    extends Bloc<DailyEvaluationEvent, DailyEvaluationState> {
  final DailyEvaluationService _service;

  DailyEvaluationBloc({required DailyEvaluationService service})
    : _service = service,
      super(const DailyEvaluationState()) {
    on<FetchDailyEvaluations>(_onFetchDailyEvaluations);
    on<CheckDailyEvaluationExist>(_onCheckDailyEvaluationExist);
    on<PatchDailyEvaluations>(_onPatchDailyEvaluations);
    on<CreateDailyEvaluations>(_onCreateDailyEvaluations);
  }



  Future<void> _onFetchDailyEvaluations(
    FetchDailyEvaluations event,
    Emitter<DailyEvaluationState> emit,
  ) async {
    emit(state.copyWith(status: DailyEvaluationStatus.loading));
    try {
      final evaluations = await _service.fetchByClassAndDate(
        event.classId,
        event.sessionDate,
      );
      emit(
        state.copyWith(
          status: DailyEvaluationStatus.loaded,
          dailyEvaluations: evaluations,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyEvaluationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCheckDailyEvaluationExist(
      CheckDailyEvaluationExist event,
      Emitter<DailyEvaluationState> emit,
      ) async {
    emit(state.copyWith(status: DailyEvaluationStatus.checkingExist));

    try {
      final exists = await _service.checkExist(event.classSessionId);

      emit(
        state.copyWith(
          status: DailyEvaluationStatus.existChecked,
          exists: exists,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyEvaluationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onPatchDailyEvaluations(
    PatchDailyEvaluations event,
    Emitter<DailyEvaluationState> emit,
  ) async {
    emit(state.copyWith(status: DailyEvaluationStatus.loading));
    try {
      await _service.patchDailyEvaluations(event.payload);
      emit(state.copyWith(
          status: DailyEvaluationStatus.patched
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyEvaluationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onCreateDailyEvaluations(
    CreateDailyEvaluations event,
    Emitter<DailyEvaluationState> emit,
  ) async {
    emit(state.copyWith(status: DailyEvaluationStatus.loading));
    try {
      await _service.createDailyEvaluations(
        event.classSessionId,
        event.payload,
      );
      emit(state.copyWith(
          status: DailyEvaluationStatus.created
      ));
    } catch (e) {
      emit(
        state.copyWith(
          status: DailyEvaluationStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
