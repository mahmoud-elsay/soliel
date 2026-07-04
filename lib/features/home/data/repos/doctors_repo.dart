import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/home/data/models/doctors_model.dart';

class DoctorsRepo {
  final ApiService _apiService;

  DoctorsRepo(this._apiService);

  Future<ApiResult<List<DoctorModel>>> getDoctors() async {
    try {
      final response = await _apiService.getDoctors();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
