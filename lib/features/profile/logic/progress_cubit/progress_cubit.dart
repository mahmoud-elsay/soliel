import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/profile/data/repo/progress_repo.dart';
import 'progress_state.dart';

class ProgressCubit extends Cubit<ProgressState> {
  final ProgressRepo _progressRepo;

  ProgressCubit(this._progressRepo) : super(const ProgressState.initial());

  Future<void> getLatestReport(int childId) async {
    emit(const ProgressState.loading());
    final result = await _progressRepo.getLatestReport(childId);
    result.when(
      success: (report) => emit(ProgressState.success(report)),
      failure: (errorHandler) =>
          emit(ProgressState.error(error: errorHandler.apiErrorModel)),
    );
  }
}
