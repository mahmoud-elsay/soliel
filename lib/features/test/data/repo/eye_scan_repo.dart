import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/test/data/models/eye_scan_request.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';

class EyeScanRepo {
  final ApiService _apiService;

  EyeScanRepo(this._apiService);

  Future<ApiResult<EyeScanResponse>> analyzeEyeScan(
    EyeScanRequest request,
  ) async {
    try {
      final response = await _apiService.analyzeEyeScan(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
