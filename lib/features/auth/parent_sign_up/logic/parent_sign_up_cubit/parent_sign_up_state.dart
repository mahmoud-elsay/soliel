import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_response_body.dart';

part 'parent_sign_up_state.freezed.dart';

@freezed
class ParentSignUpState with _$ParentSignUpState {
  const factory ParentSignUpState.initial() = _Initial;
  const factory ParentSignUpState.loading() = ParentSignUpLoading;
  const factory ParentSignUpState.success(ParentSignUpResponseBody data) =
      ParentSignUpSuccess;
  const factory ParentSignUpState.error({required ApiErrorModel error}) =
      ParentSignUpError;
}
