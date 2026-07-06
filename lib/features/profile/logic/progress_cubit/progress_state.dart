import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/profile/data/models/latest_report_response.dart';

part 'progress_state.freezed.dart';

@freezed
class ProgressState with _$ProgressState {
  const factory ProgressState.initial() = _Initial;
  const factory ProgressState.loading() = ProgressLoading;
  const factory ProgressState.success(LatestReportResponse report) =
      ProgressSuccess;
  const factory ProgressState.error({required ApiErrorModel error}) =
      ProgressError;
}
