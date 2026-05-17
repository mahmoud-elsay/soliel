import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/test/data/models/eye_scan_request.dart';
import 'package:soliel/features/test/data/models/scan_point.dart';
import 'package:soliel/features/test/data/repo/eye_scan_repo.dart';
import 'package:soliel/features/test/logic/eye_scan_cubit/eye_scan_state.dart';

class EyeScanCubit extends Cubit<EyeScanState> {
  final EyeScanRepo _eyeScanRepo;

  EyeScanCubit(this._eyeScanRepo) : super(const EyeScanState.initial());

  Future<void> analyzeEyeScan({
    required int childId,
    required String notes,
    required List<ScanPoint> scanPath,
  }) async {
    emit(const EyeScanState.loading());

    final result = await _eyeScanRepo.analyzeEyeScan(
      EyeScanRequest(childId: childId, notes: notes, scanPath: scanPath),
    );

    await result.when(
      success: (data) async {
        emit(EyeScanState.success(data));
      },
      failure: (errorHandler) async {
        emit(EyeScanState.error(error: errorHandler.apiErrorModel));
      },
    );
  }
}
