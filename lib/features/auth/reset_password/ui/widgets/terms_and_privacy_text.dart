import 'package:flutter/material.dart';
import 'package:soliel/core/theming/styles.dart';

class TermsAndPrivacyText extends StatelessWidget {
  const TermsAndPrivacyText({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyles.font14MoreDarkGreyMedium,
          children: [
            const TextSpan(text: 'By using Classroom, you agree to the\n'),
            TextSpan(
              text: 'Terms',
              style: TextStyles.font14MoreDarkGreySemiBold,
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: TextStyles.font14MoreDarkGreySemiBold,
            ),
            const TextSpan(text: '.'),
          ],
        ),
      ),
    );
  }
}
