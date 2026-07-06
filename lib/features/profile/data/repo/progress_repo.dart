import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/profile/data/models/latest_report_response.dart';

class ProgressRepo {
  final ApiService _apiService;

  ProgressRepo(this._apiService);

  Future<ApiResult<LatestReportResponse>> getLatestReport(int childId) async {
    try {
      final response = await _apiService.getLatestReport(childId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
