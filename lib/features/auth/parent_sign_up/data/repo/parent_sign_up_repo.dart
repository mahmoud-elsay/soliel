import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_request_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_response_body.dart';

class ParentSignUpRepo {
  final ApiService _apiService;

  ParentSignUpRepo(this._apiService);

  Future<ApiResult<ParentSignUpResponseBody>> registerParent(
    ParentSignUpRequestBody parentSignUpRequestBody,
  ) async {
    try {
      final response = await _apiService.registerParent(parentSignUpRequestBody);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
