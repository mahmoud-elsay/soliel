import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/home/data/models/doctors_model.dart';

part 'doctors_state.freezed.dart';

@freezed
class DoctorsState with _$DoctorsState {
  const factory DoctorsState.initial() = _Initial;
  const factory DoctorsState.loading() = DoctorsLoading;
  const factory DoctorsState.success(List<DoctorModel> doctors) =
      DoctorsSuccess;
  const factory DoctorsState.error({required ApiErrorModel error}) =
      DoctorsError;
}
