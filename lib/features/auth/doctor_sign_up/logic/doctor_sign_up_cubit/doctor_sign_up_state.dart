import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/models/doctor_sign_up_response_body.dart';

part 'doctor_sign_up_state.freezed.dart';

@freezed
class DoctorSignUpState with _$DoctorSignUpState {
  const factory DoctorSignUpState.initial() = _Initial;
  const factory DoctorSignUpState.loading() = DoctorSignUpLoading;
  const factory DoctorSignUpState.success(DoctorSignUpResponseBody data) =
      DoctorSignUpSuccess;
  const factory DoctorSignUpState.error({required ApiErrorModel error}) =
      DoctorSignUpError;
}
