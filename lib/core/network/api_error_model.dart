class ApiErrorModel {
  final String message;
  final int? code;

  ApiErrorModel({
    required this.message,
    this.code,
  });

  factory ApiErrorModel.fromJson(Map<String, dynamic> json) {
    return ApiErrorModel(
      message: (json['message'] ?? json['title'] ?? 'Unknown Error').toString(),
      code: json['statusCode'] as int? ?? json['status'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'statusCode': code,
  };
}
