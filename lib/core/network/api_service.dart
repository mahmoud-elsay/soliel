import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:soliel/core/network/api_constants.dart';
import 'package:soliel/features/auth/login/data/models/login_request_body.dart';
import 'package:soliel/features/auth/login/data/models/login_response_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_request_body.dart';
import 'package:soliel/features/auth/parent_sign_up/data/models/parent_sign_up_response_body.dart';

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
}
