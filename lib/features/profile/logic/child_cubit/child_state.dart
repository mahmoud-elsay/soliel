import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/profile/data/models/add_child_response.dart';

part 'child_state.freezed.dart';

@freezed
class ChildState with _$ChildState {
  const factory ChildState.initial() = _Initial;
  const factory ChildState.loading() = ChildLoading;
  const factory ChildState.success(AddChildResponse response) = ChildSuccess;
  const factory ChildState.error({required ApiErrorModel error}) = ChildError;
}
