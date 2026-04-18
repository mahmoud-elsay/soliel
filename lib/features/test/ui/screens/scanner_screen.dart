import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:soliel/core/theming/styles.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final ImagePicker _picker = ImagePicker();
  String? _pickedImagePath;

  Future<void> _pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(source: source);
    if (image != null && mounted) {
      setState(() {
        _pickedImagePath = image.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3F3F3F), // Dark background for scanner
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  Icons.close,
                  color: Colors.white,
                  size: 30.r,
                ),
              ),
            ),
            SizedBox(height: 20.h),
            Text(
              'ابدأ المسح الآن',
              style: TextStyles.font24GradientExtraBold.copyWith(
                color: Colors.white,
                fontSize: 30.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10.h),
            Text(
              'وجه الكاميرا نحو الطفل لتحليل الحاله',
              style: TextStyles.font14GreyMedium.copyWith(
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            _buildScannerOverlay(),
            const Spacer(),
            if (_pickedImagePath != null)
              ElevatedButton(
                onPressed: () => Navigator.pop(context, _pickedImagePath),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 12.h),
                ),
                child: Text('تأكيد', style: TextStyles.font16WhiteSemiBold),
              )
            else
              _buildLoadingIndicator(),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUploadOption(),
                SizedBox(width: 40.w),
                _buildCaptureOption(),
              ],
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Container(
      width: 330.w,
      height: 200.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        children: [
          if (_pickedImagePath != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Image.file(
                File(_pickedImagePath!),
                width: 330.w,
                height: 200.h,
                fit: BoxFit.cover,
              ),
            )
          else
            Center(
              child: Container(
                width: 310.w,
                height: 2.h,
                color: Colors.orange, // Scanning line
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Column(
      children: [
        SizedBox(
          width: 80.r,
          height: 80.r,
          child: CircularProgressIndicator(
            value: 0.7, // Example progress
            strokeWidth: 8.r,
            backgroundColor: Colors.white.withOpacity(0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
        SizedBox(height: 20.h),
        Text(
          'بانتظار الطفل',
          style: TextStyles.font20BlackSemiBold.copyWith(
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadOption() {
    return Column(
      children: [
        IconButton(
          onPressed: () => _pickImage(ImageSource.gallery),
          icon: Icon(
            Icons.cloud_upload,
            color: Colors.white,
            size: 40.r,
          ),
        ),
        Text(
          'رفع صورة',
          style: TextStyles.font12BlackRegular.copyWith(color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildCaptureOption() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _pickImage(ImageSource.camera),
          child: Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 4),
            ),
            child: Center(
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'التقاط',
          style: TextStyles.font12BlackRegular.copyWith(color: Colors.white),
        ),
      ],
    );
  }
}
