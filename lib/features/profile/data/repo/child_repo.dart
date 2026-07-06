import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/profile/data/models/add_child_request.dart';
import 'package:soliel/features/profile/data/models/add_child_response.dart';

class ChildRepo {
  final ApiService _apiService;

  ChildRepo(this._apiService);

  Future<ApiResult<AddChildResponse>> addChild(AddChildRequest request) async {
    try {
      final response = await _apiService.addChild(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
