import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soliel/core/theming/colors_manger.dart';
import 'package:soliel/core/theming/styles.dart';
import 'package:soliel/features/home/data/models/doctors_model.dart';

class HomeDoctorCard extends StatelessWidget {
  final DoctorModel doctor;

  const HomeDoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    final certificateImageUrl = doctor.certificateImageUrl.isNotEmpty
        ? doctor.certificateImageUrl
        : doctor.profileImageUrl;

    return Container(
      margin: EdgeInsets.only(left: 12.w),
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: EdgeInsets.all(8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Row: big image on the right + two stacked image boxes on the left
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: two stacked image boxes
              Column(
                children: [
                  _ImageBox(
                    imageUrl: certificateImageUrl,
                    width: 130.w,
                    height: 67.5.h,
                  ),
                  SizedBox(height: 8.h),
                  _ImageBox(
                    imageUrl: doctor.profileImageUrl,
                    width: 130.w,
                    height: 67.5.h,
                  ),
                ],
              ),

              SizedBox(width: 8.w),

              // Right: large doctor image
              ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: _NetworkOrAssetImage(
                  imageUrl: doctor.profileImageUrl,
                  width: 160.w,
                  height: 143.h,
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Doctor name below both columns
          Text(
            doctor.fullName,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.font17DarkForestSemiBold,
          ),
        ],
      ),
    );
  }
}

class _ImageBox extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;

  const _ImageBox({
    required this.imageUrl,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.r),
      child: _NetworkOrAssetImage(
        imageUrl: imageUrl,
        width: width,
        height: height,
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
