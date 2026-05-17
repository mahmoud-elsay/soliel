import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

class ScanResultAdviceList extends StatelessWidget {
  final String recommendation;

  const ScanResultAdviceList({super.key, required this.recommendation});

  static const List<String> _defaultTips = [
    'ساعده على بناء روتين يومي واضح ويمكن التنبؤ به؛ فالروتين يمنحه شعوراً بالأمان ويقلل التوتر.',
    'راقبه لتتعرف على المحفزات الحسية المزعجة مثل الضوضاء أو الإضاءة القوية، ثم خففها قدر الإمكان.',
    'شجعه على التعبير عن احتياجاته بكلمات بسيطة ومباشرة عند حاجته للمساعدة أو الراحة.',
    'ادعم نقاط قوته واهتماماته الخاصة، فهي وسيلة فعالة لبناء الثقة والتواصل مع العالم من حوله.',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: const Color(0xFFF4FBFA),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: const Color(0xFFBFE7E3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (recommendation.trim().isNotEmpty) ...[
            Text(
              recommendation,
              style: TextStyles.font14GreyMedium.copyWith(
                color: ColorsManager.black,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(height: 14.h),
          ],
          Expanded(
            child: ListView.separated(
              itemCount: _defaultTips.length,
              separatorBuilder: (_, index) => SizedBox(height: 14.h),
              itemBuilder: (context, index) {
                return Text(
                  '(${index + 1}) ${_defaultTips[index]}',
                  style: TextStyles.font14GreyMedium.copyWith(
                    color: ColorsManager.black,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
