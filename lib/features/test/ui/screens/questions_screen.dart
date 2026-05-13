import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

class QuestionsArgs {
  final String title;
  final String imagePath;

  QuestionsArgs({required this.title, required this.imagePath});
}

class QuestionModel {
  final String question;
  final List<String> options;
  int? selectedIndex;

  QuestionModel({required this.question, required this.options, this.selectedIndex});
}

class QuestionsScreen extends StatefulWidget {
  final QuestionsArgs args;
  const QuestionsScreen({super.key, required this.args});

  @override
  State<QuestionsScreen> createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final List<QuestionModel> _questions = [
    QuestionModel(
      question: '1. هل يقوم الطفل بحركات متكررة مثل رفرفة اليدين أو الدوران؟',
      options: [
        'لا يقوم بأي حركات متكررة',
        'تظهر أحياناً عند التوتر أو الفرح',
        'تظهر بوضوح يومياً في مواقف متعددة',
        'حركات مستمرة ومكثفة يصعب إيقافها',
      ],
    ),
    QuestionModel(
      question: '2. هل يتقبل التغيير في الروتين أو المكان بسهولة؟',
      options: [
        'يتأقلم بسهولة مع التغيير',
        'يحتاج وقتاً قصيراً للتأقلم',
        'يرفض التغيير في البداية بشكل واضح',
        'يرفض التغيير تماماً ويظهر قلقاً شديداً',
      ],
    ),
    QuestionModel(
      question: '3. هل يتفاعل مع الأصوات أو اللمس بطريقة طبيعية؟',
      options: [
        'استجابته الحسية طبيعية',
        'أحياناً يتضايق من أصوات معينة أو لمس خفيف',
        'يظهر حساسية مفرطة أو تجنب متكرر',
        'لا يتحمل الأصوات أو اللمس إطلاقاً أو يتجاهلها تماماً',
      ],
    ),
    QuestionModel(
      question: '4. هل يستطيع التركيز على نشاط واحد لفترة مناسبة لعمره؟',
      options: [
        'يركز لفترة طبيعية',
        'يتشتت أحياناً ويحتاج تذكيراً خفيفاً',
        'يتشتت باستمرار ويحتاج مساعدة للعودة للنشاط',
        'لا يستطيع التركيز على الإطلاق',
      ],
    ),
    QuestionModel(
      question: '5. هل يتفاعل مع الألعاب أو الأنشطة الجديدة بطريقة مناسبة؟',
      options: [
        'يستكشف ويتفاعل بسهولة',
        'يتردد في البداية ثم يشارك',
        'يحتاج مساعدة وتشجيع قوي',
        'يرفض المشاركة أو يظهر قلقاً واضحاً',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                itemCount: _questions.length,
                itemBuilder: (context, index) {
                  return _buildQuestionItem(_questions[index]);
                },
              ),
            ),
            _buildBottomButton(),
          ],
        ),
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

  Widget _buildQuestionItem(QuestionModel question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          question.question,
          style: TextStyles.font18RobotoBlackSemiBold,
          textAlign: TextAlign.right,
        ),
        SizedBox(height: 10.h),
        ...question.options.asMap().entries.map((entry) {
          int idx = entry.key;
          String option = entry.value;
          return _buildOptionItem(question, idx, option);
        }),
        SizedBox(height: 25.h),
      ],
    );
  }

  Widget _buildOptionItem(QuestionModel question, int idx, String option) {
    bool isSelected = question.selectedIndex == idx;
    return GestureDetector(
      onTap: () {
        setState(() {
          question.selectedIndex = idx;
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

  Widget _buildBottomButton() {
    bool isLast = true; // For now
    return Padding(
      padding: EdgeInsets.all(20.r),
      child: Container(
        width: double.infinity,
        height: 50.h,
        decoration: BoxDecoration(
          gradient: ColorsManager.primaryGradient,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Text(
            isLast ? 'حفظ البيانات' : 'التالي', 
            style: TextStyles.font16WhiteSemiBold,
          ),
        ),
      ),
    );
  }
}
