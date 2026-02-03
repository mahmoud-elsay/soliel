class OnboardingModel {
  final String image;
  final String title;
  final String subtitle;
  final bool isCurveRight; // true for right curve, false for left curve

  OnboardingModel({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.isCurveRight,
  });

  static List<OnboardingModel> onboardingPages = [
    OnboardingModel(
      image: 'assets/images/first_onboarding.png',
      title: 'فحص بسيط.. فهم أعمق✨',
      subtitle:
          'مرحباً بك في عالم يساعدك تفهم أكثر!\n'
          'مع تقنية المسح الذكي، نراقب باهتمام (بموافقتك طبعاً) بعض السلوكيات البسيطة خلال تفاعلك مع التطبيق.',
      isCurveRight: true,
    ),
    OnboardingModel(
      image: 'assets/images/second_onboarding.png',
      title: 'رحلة جميلة مع طفلك 🌈',
      subtitle:
          'فهم طفلك أكثر 💜\n\n'
          'كل طفل توحدي هو عالم خاص ومختلف\n'
          'التطبيق ده هيخليك تفهم عالم طفلك أكتر',
      isCurveRight: false,
    ),
    OnboardingModel(
      image: 'assets/images/last_onboarding.png',
      title: 'الألعاب مش مجرد تسلية.. الألعاب بنتعلم ونتورا 🧠',
      subtitle:
          '"مرحباً بك في القسم الألعاب الخاص بتاعك!\n'
          'هنا كل لعبة بتعمل بتعطيك فرصة مفيدة، مش مجرد تسليه\n'
          'وقت..\n'
          'الألعاب دي مصممة ليدي متخصصين\n'
          'وتتورا كيف طفلك بدأي خطوة خطوة',
      isCurveRight: false,
    ),
  ];
}
