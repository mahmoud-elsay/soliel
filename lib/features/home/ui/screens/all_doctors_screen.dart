import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/di/dependency_injection.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';

import 'package:soliel/features/home/logic/doctors_cubit/doctors_state.dart';
import 'package:soliel/features/home/logic/doctors_cubit/doctors_cubit.dart';
import 'package:soliel/features/home/ui/widgets/horizontal_doctor_card.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<DoctorsCubit>()..getDoctors(),
      child: Scaffold(
        backgroundColor: ColorsManager.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                verticalSpace(20),
                _buildHeader(context),
                verticalSpace(30),
                Expanded(
                  child: BlocBuilder<DoctorsCubit, DoctorsState>(
                    builder: (context, state) {
                      if (state is DoctorsLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is DoctorsSuccess) {
                        if (state.doctors.isEmpty) {
                          return Center(
                            child: Text(
                              'لا يوجد دكاتره متاحين حالياً',
                              style: TextStyles.font14GreyMedium,
                            ),
                          );
                        }
                        return ListView.builder(
                          itemCount: state.doctors.length,
                          itemBuilder: (context, index) =>
                              HorizontalDoctorCard(doctor: state.doctors[index]),
                        );
                      } else if (state is DoctorsError) {
                        return Center(
                          child: Text(
                            'حدث خطأ أثناء تحميل الدكاتره',
                            style: TextStyles.font14GreyMedium,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(width: 44.w), // Placeholder to maintain centered title balance
        Text(
          'دكاتره متاحه',
          style: TextStyles.font20BlackSemiBold.copyWith(
            color: const Color(0xFF1E232C),
          ),
        ),
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              border: Border.all(color: ColorsManager.greyBorderColor),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 20.sp,
              color: const Color(0xFF1E232C),
            ),
          ),
        ),
      ],
    );
  }
}
