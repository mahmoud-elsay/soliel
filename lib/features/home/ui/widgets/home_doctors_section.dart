import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/di/dependency_injection.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/routing/routes.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/core/widgets/app_gradient_text.dart';

import 'package:soliel/features/home/logic/doctors_cubit/doctors_state.dart';
import 'package:soliel/features/home/logic/doctors_cubit/doctors_cubit.dart';
import 'package:soliel/features/home/ui/widgets/home_doctor_card.dart';

class HomeDoctorsSection extends StatelessWidget {
  const HomeDoctorsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DoctorsCubit>()..getDoctors(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Section header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "شاهد الكل" on the left
                GestureDetector(
                  onTap: () {
                    context.pushNamed(Routes.allDoctorsScreen);
                  },
                  child: Text('شاهد الكل', style: TextStyles.font14GreyMedium),
                ),

                // "اقتراحات دكاتره" gradient title on the right
                AppGradientText(
                  gradient: ColorsManager.primaryGradient,
                  child: Text(
                    'اقتراحات دكاتره',
                    textDirection: TextDirection.rtl,
                    style: TextStyles.font20GradientSemiBold,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 14.h),

          // Horizontal list of doctor cards, backed by the API
          SizedBox(
            height: 210.h,
            child: BlocBuilder<DoctorsCubit, DoctorsState>(
              builder: (context, state) {
                return state.when(
                  initial: () => const SizedBox.shrink(),
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  success: (doctors) {
                    if (doctors.isEmpty) {
                      return Center(
                        child: Text(
                          'لا يوجد دكاتره متاحين حالياً',
                          style: TextStyles.font14GreyMedium,
                        ),
                      );
                    }
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // RTL ordering
                      padding: EdgeInsets.only(right: 20.w, left: 8.w),
                      itemCount: doctors.length,
                      itemBuilder: (context, index) =>
                          HomeDoctorCard(doctor: doctors[index]),
                    );
                  },
                  error: (error) => Center(
                    child: Text(
                      'حدث خطأ أثناء تحميل الدكاتره',
                      style: TextStyles.font14GreyMedium,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
