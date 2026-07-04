class ApiConstants {
  static const String apiBaseUrl = 'https://soleilahmeda.runasp.net/api/';

  static const String login = 'Account/login';
  static const String registerParent = 'Account/register-parent';
  static const String registerDoctor = 'Account/register-doctor';
  static const String eyeScanAnalyze = 'EyeScan/analyze';
  static const String doctorsList = 'Doctor/list';
  static const String assessmentFields = 'Assessment/get-all-fields';
  static const String assessmentQuestionsByField =
      'Assessment/get-questions-by-field/{fieldId}';
  static const String submitQuestionnaire = 'Assessment/submit-questionnaire';

  static String doctorImageUrl(String imagePath) {
    final trimmedPath = imagePath.trim();
    if (trimmedPath.isEmpty) return '';

    final uri = Uri.tryParse(trimmedPath);
    if (uri != null && uri.hasScheme) return trimmedPath;

    return Uri.parse(apiBaseUrl).resolve(trimmedPath).toString();
  }
}

class ApiErrors {
  static const String badRequestError = "badRequestError";
  static const String noContent = "noContent";
  static const String forbiddenError = "forbiddenError";
  static const String unauthorizedError = "unauthorizedError";
  static const String notFoundError = "notFoundError";
  static const String conflictError = "conflictError";
  static const String internalServerError = "internalServerError";
  static const String unknownError = "unknownError";
  static const String timeoutError = "timeoutError";
  static const String defaultError = "defaultError";
  static const String cacheError = "cacheError";
  static const String noInternetError = "noInternetError";
  static const String loadingMessage = "loading_message";
  static const String retryAgainMessage = "retry_again_message";
  static const String ok = "Ok";
}
