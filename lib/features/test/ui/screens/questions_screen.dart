import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/shared_pref_helper.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_loading_indicator.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';
import 'package:soliel/core/widgets/custom_snack_bar.dart';
import 'package:soliel/features/test/data/models/assessment_field_model.dart';
import 'package:soliel/features/test/data/models/assessment_question_model.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_request.dart';
import 'package:soliel/features/test/data/models/submit_questionnaire_response.dart';
import 'package:soliel/features/test/logic/assessment_cubit/assessment_cubit.dart';
import 'package:soliel/features/test/logic/assessment_cubit/assessment_state.dart';
import 'package:soliel/features/test/ui/screens/questionnaire_result_screen.dart';

class QuestionsArgs {
  final String title;
  final String imagePath;
  final int? fieldId;
  final int childId;

  QuestionsArgs({
    required this.title,
    required this.imagePath,
    this.fieldId,
    this.childId = 1,
  });
}

class QuestionsScreen extends StatefulWidget {
  final QuestionsArgs args;
  const QuestionsScreen({super.key, required this.args});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  static const List<String> _scoreOptions = [
    'لا يحدث',
    'يحدث أحياناً',
    'يحدث غالباً',
    'يحدث دائماً',
  ];

  final Map<int, int> _selectedScores = {};
  List<AssessmentQuestionModel> _questions = [];
  List<AssessmentFieldModel> _fields = [];
  bool _submitLoadingVisible = false;
  int _childId = 1;

  @override
  void initState() {
    super.initState();
    _loadChildId();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final fieldId = widget.args.fieldId;
      if (fieldId != null) {
        context.read<AssessmentCubit>().getQuestionsByField(fieldId);
      } else {
        context.read<AssessmentCubit>().getAssessmentFields();
      }
    });
  }

  Future<void> _loadChildId() async {
    _childId = await StorageHelper.getChildId();
  }

  @override
  void dispose() {
    _hideSubmitLoading();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AssessmentCubit, AssessmentState>(
      listener: _handleAssessmentState,
      builder: (context, state) {
        final isLoadingQuestions = state.maybeWhen(
          fieldsLoading: () => true,
          questionsLoading: () => true,
          orElse: () => false,
        );
        final isSubmitting = state.maybeWhen(
          submitLoading: () => true,
          orElse: () => false,
        );

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                _buildAppBar(context),
                Expanded(child: _buildBody(isLoadingQuestions)),
                _buildBottomButton(context, isSubmitting),
              ],
            ),
          ),
        );
      },
    );
  }

  void _handleAssessmentState(BuildContext context, AssessmentState state) {
    state.whenOrNull(
      fieldsSuccess: (fields) {
        _fields = fields;
        final field = _findFieldForCurrentArgs(fields);
        if (field == null) {
          CustomSnackBar.show(
            context,
            message: 'تعذر تحديد مجال الاختبار',
            state: SnackBarState.error,
          );
          return;
        }

        context.read<AssessmentCubit>().getQuestionsByField(field.id);
      },
      questionsSuccess: (questions) {
        final previousScores = Map<int, int>.from(_selectedScores);
        setState(() {
          _questions = questions;
          _selectedScores
            ..clear()
            ..addEntries(
              questions
                  .where((question) => previousScores.containsKey(question.id))
                  .map((question) {
                    return MapEntry(question.id, previousScores[question.id]!);
                  }),
            );
        });
      },
      submitLoading: _showSubmitLoading,
      submitSuccess: (response) {
        if (!mounted) return;
        _hideSubmitLoading();
        Navigator.pushNamed(
          context,
          Routes.questionnaireResultScreen,
          arguments: _resultsFromResponse(response),
        );
      },
      error: (error) {
        if (!mounted) return;
        _hideSubmitLoading();
        CustomSnackBar.show(
          context,
          message: error.message,
          state: SnackBarState.error,
        );
      },
    );
  }

  AssessmentFieldModel? _findFieldForCurrentArgs(
    List<AssessmentFieldModel> fields,
  ) {
    final normalizedTitle = _normalizeArabic(widget.args.title);
    for (final field in fields) {
      final normalizedName = _normalizeArabic(field.name);
      if (normalizedTitle == normalizedName ||
          normalizedTitle.contains(normalizedName) ||
          normalizedName.contains(normalizedTitle)) {
        return field;
      }
    }

    return null;
  }

  String _normalizeArabic(String value) {
    return value
        .replaceAll('\n', ' ')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('آ', 'ا')
        .replaceAll('ة', 'ه')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  void _showSubmitLoading() {
    if (_submitLoadingVisible) return;
    _submitLoadingVisible = true;
    showAppLoading(context, 'جاري حفظ الإجابات...');
  }

  void _hideSubmitLoading() {
    if (!_submitLoadingVisible || !mounted) return;
    final navigator = Navigator.of(context, rootNavigator: true);
    if (navigator.canPop()) {
      navigator.pop();
    }
    _submitLoadingVisible = false;
  }

  List<DomainResult> _resultsFromResponse(
    SubmitQuestionnaireResponse response,
  ) {
    return response.summary.map((item) {
      final score = _percentageFromScore(item.score);
      final fieldName = _fieldNameById(item.fieldId);

      return DomainResult(
        title: fieldName ?? 'مجال ${item.fieldId}',
        percentage: score,
        iconAsset: _iconAssetForField(fieldName ?? widget.args.title),
      );
    }).toList();
  }

  double _percentageFromScore(String value) {
    final parsed = double.tryParse(value.replaceAll('%', '').trim()) ?? 0;
    if (parsed <= 1) return parsed.clamp(0.0, 1.0);
    return (parsed / 100).clamp(0.0, 1.0);
  }

  String? _fieldNameById(int fieldId) {
    for (final field in _fields) {
      if (field.id == fieldId) return field.name;
    }
    return null;
  }

  String _iconAssetForField(String fieldName) {
    final normalizedName = _normalizeArabic(fieldName);
    if (normalizedName.contains('تواصل')) {
      return 'assets/svgs/social_result_icon.svg';
    }
    if (normalizedName.contains('تفاعل')) {
      return 'assets/svgs/interact_result_icon.svg';
    }
    return 'assets/svgs/skills_result.svg';
  }

  Widget _buildBody(bool isLoadingQuestions) {
    if (isLoadingQuestions && _questions.isEmpty) {
      return const AppLoadingIndicator(message: 'جاري تحميل الأسئلة...');
    }

    if (_questions.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            'لا توجد أسئلة متاحة لهذا المجال',
            style: TextStyles.font16GradientMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      itemCount: _questions.length,
      itemBuilder: (context, index) {
        return _buildQuestionItem(index, _questions[index]);
      },
    );
  }

  void _submitAnswers() {
    if (_questions.isEmpty) return;

    final answers = _questions.map((question) {
      return QuestionnaireAnswerModel(
        questionId: question.id,
        score: _selectedScores[question.id] ?? 0,
      );
    }).toList();

    context.read<AssessmentCubit>().submitQuestionnaire(
      childId: _childId,
      answers: answers,
    );
  }

  int get _answeredCount => _questions
      .where((question) => _selectedScores.containsKey(question.id))
      .length;

  Widget _buildProgressSummary() {
    final progress = _questions.isEmpty
        ? 0.0
        : _answeredCount / _questions.length;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                '$_answeredCount / ${_questions.length}',
                style: TextStyles.font14RobotoGreySemiBold,
              ),
              const Spacer(),
              Text(
                'تمت الإجابة',
                style: TextStyles.font14RobotoGreySemiBold,
                textAlign: TextAlign.right,
              ),
            ],
          ),
          verticalSpace(8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: ColorsManager.greyBorderColor,
              valueColor: const AlwaysStoppedAnimation<Color>(
                ColorsManager.primaryGradientStart,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: ColorsManager.greyBorderColor),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 18.r,
                color: ColorsManager.primaryGradientStart,
              ),
            ),
          ),
          const Spacer(),
          Expanded(
            flex: 4,
            child: Column(
              children: [
                AppGradientText(
                  gradient: ColorsManager.primaryGradient,
                  child: Text(
                    'الاختبار',
                    style: TextStyles.font20GradientSemiBold,
                  ),
                ),
                AppGradientText(
                  gradient: ColorsManager.primaryGradient,
                  child: Text(
                    widget.args.title.replaceAll('\n', ' '),
                    style: TextStyles.font16GradientMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          Image.asset(
            widget.args.imagePath,
            width: 80.w,
            height: 80.h,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionItem(int index, AssessmentQuestionModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '${index + 1}. ${question.text}',
          style: TextStyles.font18RobotoBlackSemiBold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10.h),
        ..._scoreOptions.asMap().entries.map((entry) {
          int idx = entry.key;
          String option = entry.value;
          return _buildOptionItem(question, idx, option);
        }),
        SizedBox(height: 25.h),
      ],
    );
  }

  Widget _buildOptionItem(
    AssessmentQuestionModel question,
    int idx,
    String option,
  ) {
    final isSelected = _selectedScores[question.id] == idx;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedScores[question.id] = idx;
        });
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          children: [
            Expanded(
              child: Text(
                option,
                style: TextStyles.font14RobotoGreySemiBold,
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(width: 10.w),
            Container(
              width: 20.r,
              height: 20.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: ColorsManager.primaryGradientStart,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12.r,
                        height: 12.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorsManager.primaryGradientStart,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomButton(BuildContext context, bool isSubmitting) {
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildProgressSummary(),
          verticalSpace(16),
          Container(
            width: double.infinity,
            height: 50.h,
            decoration: BoxDecoration(
              gradient: ColorsManager.primaryGradient,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: ElevatedButton(
              onPressed: isSubmitting ? null : _submitAnswers,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: ColorsManager.greyBorderColor,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Text(
                isSubmitting ? 'جاري الحفظ...' : 'حفظ البيانات',
                style: TextStyles.font16WhiteSemiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
