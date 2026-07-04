import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:soliel/core/network/api_error_model.dart';
import 'package:soliel/features/test/data/models/assessment_field_model.dart';
import 'package:soliel/features/test/data/models/assessment_question_model.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_response.dart';

part 'assessment_state.freezed.dart';

@freezed
class AssessmentState with _$AssessmentState {
  const factory AssessmentState.initial() = _Initial;
  const factory AssessmentState.fieldsLoading() = AssessmentFieldsLoading;
  const factory AssessmentState.fieldsSuccess(
    List<AssessmentFieldModel> fields,
  ) = AssessmentFieldsSuccess;
  const factory AssessmentState.questionsLoading() = AssessmentQuestionsLoading;
  const factory AssessmentState.questionsSuccess(
    List<AssessmentQuestionModel> questions,
  ) = AssessmentQuestionsSuccess;
  const factory AssessmentState.submitLoading() = AssessmentSubmitLoading;
  const factory AssessmentState.submitSuccess(
    SubmitQuestionnaireResponse response,
  ) = AssessmentSubmitSuccess;
  const factory AssessmentState.error({required ApiErrorModel error}) =
      AssessmentError;
}
