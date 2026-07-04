import 'package:soliel/core/network/api_error_handler.dart';
import 'package:soliel/core/network/api_result.dart';
import 'package:soliel/core/network/api_service.dart';
import 'package:soliel/features/test/data/models/assessment_field_model.dart';
import 'package:soliel/features/test/data/models/assessment_question_model.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_request.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_response.dart';

class AssessmentRepo {
  final ApiService _apiService;

  AssessmentRepo(this._apiService);

  Future<ApiResult<List<AssessmentFieldModel>>> getAssessmentFields() async {
    try {
      final response = await _apiService.getAssessmentFields();
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<List<AssessmentQuestionModel>>> getQuestionsByField(
    int fieldId,
  ) async {
    try {
      final response = await _apiService.getAssessmentQuestionsByField(fieldId);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SubmitQuestionnaireResponse>> submitQuestionnaire(
    SubmitQuestionnaireRequest request,
  ) async {
    try {
      final response = await _apiService.submitQuestionnaire(request);
      return ApiResult.success(response);
    } catch (error) {
      return ApiResult.failure(ErrorHandler.handle(error));
    }
  }
}
