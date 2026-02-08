import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:soliel/core/widgets/social_media_container.dart';

class SocialMediaButtons extends StatelessWidget {
  const SocialMediaButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SocialMediaContainer(iconImage: 'assets/svgs/google_icon.svg'),
        const SocialMediaContainer(iconImage: 'assets/svgs/facebook_icon.svg'),
        if (Platform.isIOS)
          const SocialMediaContainer(iconImage: 'assets/svgs/apple_icon.svg'),
      ],
    );
  }
}
