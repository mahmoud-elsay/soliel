import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_request.dart';
import 'package:soliel/features/test/data/repo/assessment_repo.dart';
import 'package:soliel/features/test/logic/assessment_cubit/assessment_state.dart';

class AssessmentCubit extends Cubit<AssessmentState> {
  final AssessmentRepo _assessmentRepo;

  AssessmentCubit(this._assessmentRepo)
    : super(const AssessmentState.initial());

  Future<void> getAssessmentFields() async {
    emit(const AssessmentState.fieldsLoading());

    final result = await _assessmentRepo.getAssessmentFields();

    result.when(
      success: (fields) => emit(AssessmentState.fieldsSuccess(fields)),
      failure: (errorHandler) =>
          emit(AssessmentState.error(error: errorHandler.apiErrorModel)),
    );
  }

  Future<void> getQuestionsByField(int fieldId) async {
    emit(const AssessmentState.questionsLoading());

    final result = await _assessmentRepo.getQuestionsByField(fieldId);

    result.when(
      success: (questions) => emit(AssessmentState.questionsSuccess(questions)),
      failure: (errorHandler) =>
          emit(AssessmentState.error(error: errorHandler.apiErrorModel)),
    );
  }

  Future<void> submitQuestionnaire({
    required int childId,
    required List<QuestionnaireAnswerModel> answers,
  }) async {
    emit(const AssessmentState.submitLoading());

    final result = await _assessmentRepo.submitQuestionnaire(
      SubmitQuestionnaireRequest(childId: childId, answers: answers),
    );

    result.when(
      success: (response) => emit(AssessmentState.submitSuccess(response)),
      failure: (errorHandler) =>
          emit(AssessmentState.error(error: errorHandler.apiErrorModel)),
    );
  }
}
