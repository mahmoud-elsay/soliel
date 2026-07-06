import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/models/doctor_sign_up_request_body.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/models/doctor_sign_up_response_body.dart';

class DoctorSignUpRepo {
  final ApiService _apiService;

  DoctorSignUpRepo(this._apiService);

  Future<ApiResult<DoctorSignUpResponseBody>> registerDoctor(
    DoctorSignUpRequestBody doctorSignUpRequestBody,
  ) async {
    try {
      final response = await _apiService.registerDoctor(
        doctorSignUpRequestBody.firstName,
        doctorSignUpRequestBody.lastName,
        doctorSignUpRequestBody.email,
        doctorSignUpRequestBody.password,
        doctorSignUpRequestBody.clinicPhone,
        doctorSignUpRequestBody.nationalId,
        doctorSignUpRequestBody.experienceYears,
        doctorSignUpRequestBody.city,
        doctorSignUpRequestBody.street,
        doctorSignUpRequestBody.building,
        doctorSignUpRequestBody.education,
        doctorSignUpRequestBody.workingHours,
        doctorSignUpRequestBody.certificateImage,
        doctorSignUpRequestBody.profileImage,
      );
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
