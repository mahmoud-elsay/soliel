import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/auth/login/data/models/login_response_body.dart';

part 'login_state.freezed.dart';

@freezed
class LoginState with _$LoginState {
  const factory LoginState.initial() = _Initial;
  const factory LoginState.loading() = LoginLoading;
  const factory LoginState.success(LoginResponseBody data) = LoginSuccess;
  const factory LoginState.error({required ApiErrorModel error}) = LoginError;
}
