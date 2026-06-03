import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:soliel/core/network/api_constants.dart';
import 'package:soliel/features/auth/doctor_sign_up/data/models/doctor_sign_up_response_body.dart';
import 'package:soliel/features/auth/login/data/models/login_request_body.dart';
import 'package:soliel/features/auth/login/data/models/login_response_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_request_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_response_body.dart';
import 'package:soliel/features/test/data/models/eye_scan_request.dart';
import 'package:soliel/features/test/data/models/eye_scan_response.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: ApiConstants.apiBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;

  // Authentication APIs
  @POST(ApiConstants.login)
  Future<LoginResponseBody> login(@Body() LoginRequestBody loginRequestBody);

  @POST(ApiConstants.registerParent)
  Future<ParentSignUpResponseBody> registerParent(
    @Body() ParentSignUpRequestBody parentSignUpRequestBody,
  );

  @MultiPart()
  @POST(ApiConstants.registerDoctor)
  Future<DoctorSignUpResponseBody> registerDoctor(
    @Part(name: 'FirstName') String firstName,
    @Part(name: 'LastName') String lastName,
    @Part(name: 'Email') String email,
    @Part(name: 'Password') String password,
    @Part(name: 'ClinicPhone') String clinicPhone,
    @Part(name: 'NationalId') String nationalId,
    @Part(name: 'ExperienceYears') int experienceYears,
    @Part(name: 'City') String city,
    @Part(name: 'Street') String street,
    @Part(name: 'Building') String building,
    @Part(name: 'Education') String education,
    @Part(name: 'WorkingHours') String workingHours,
    @Part(name: 'CertificateImage') File certificateImage,
  );

  @POST(ApiConstants.eyeScanAnalyze)
  Future<EyeScanResponse> analyzeEyeScan(@Body() EyeScanRequest request);
}
