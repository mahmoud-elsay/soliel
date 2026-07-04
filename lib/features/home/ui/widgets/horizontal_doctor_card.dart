import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/helpers/spacing.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/home/data/models/doctors_model.dart';

class HorizontalDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const HorizontalDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                verticalSpace(12),
                Text(
                  doctor.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.font16BlackSemiBold.copyWith(
                    fontSize: 18.sp,
                    color: ColorsManager.black,
                  ),
                ),
                verticalSpace(4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        doctor.city,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.font14GreyMedium.copyWith(
                          fontSize: 14.sp,
                          color: ColorsManager.lightGrey,
                        ),
                      ),
                    ),
                    horizontalSpace(4),
                    Icon(
                      Icons.location_on,
                      color: ColorsManager.lightGrey,
                      size: 16.sp,
                    ),
                  ],
                ),
                verticalSpace(8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE4EDF7), // light blue background
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 160.w),
                    child: Text(
                      doctor.education,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.font14PrimaryGradientStartMedium
                          .copyWith(
                            fontSize: 12.sp,
                            color: const Color(0xFF5D9EF6),
                          ),
                    ),
                  ),
                ),
                verticalSpace(6),
                Text(
                  '${doctor.experienceYears} سنوات خبرة',
                  textDirection: TextDirection.rtl,
                  style: TextStyles.font14GreyMedium.copyWith(
                    fontSize: 12.sp,
                    color: ColorsManager.lightGrey,
                  ),
                ),
              ],
            ),
          ),
          horizontalSpace(16),
          // Doctor Image
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: _NetworkOrAssetImage(
              imageUrl: doctor.profileImageUrl,
              width: 100.w,
              height: 100.h,
            ),
          ),
        ],
      ),
    );
  }
}

class _NetworkOrAssetImage extends StatelessWidget {
  static const String _fallbackAsset =
      'assets/images/doctor_container_image.jpg';

  final String imageUrl;
  final double width;
  final double height;

  const _NetworkOrAssetImage({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl.isEmpty) return _assetImage();

    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: BoxFit.cover,
      placeholder: (_, __) => SizedBox(width: width, height: height),
      errorWidget: (_, __, ___) => _assetImage(),
    );
  }

  Widget _assetImage() {
    return Image.asset(
      _fallbackAsset,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }
}
