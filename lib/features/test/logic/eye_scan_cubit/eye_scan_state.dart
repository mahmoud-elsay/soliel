import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';

part 'eye_scan_state.freezed.dart';

@freezed
class EyeScanState with _$EyeScanState {
  const factory EyeScanState.initial() = _Initial;
  const factory EyeScanState.loading() = _Loading;
  const factory EyeScanState.success(EyeScanResponse data) = _Success;
  const factory EyeScanState.error({required ApiErrorModel error}) = _Error;
}
