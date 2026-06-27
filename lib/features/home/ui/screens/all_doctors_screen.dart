import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/extensions.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/home/ui/widgets/horizontal_doctor_card.dart';

class AllDoctorsScreen extends StatelessWidget {
  const AllDoctorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                child: ListView.builder(
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final names = ['د/ هاله محمد', 'د/ محمد محمود', 'د/ ساره احمد'];
                    final distances = ['80m away', '70m away', '520m away'];
                    final images = [
                      'assets/images/doctor_avatar.jpg',
                      'assets/images/doctor_container_image.jpg',
                      'assets/images/doctor_avatar.jpg',
                    ];
                    return HorizontalDoctorCard(
                      name: names[index],
                      distance: distances[index],
                      rating: '4.7',
                      imagePath: images[index % images.length],
                    );
                  },
                ),
              ),
            ],
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
