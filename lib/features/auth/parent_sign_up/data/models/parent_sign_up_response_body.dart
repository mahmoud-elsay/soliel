import 'package:json_annotation/json_annotation.dart';

part 'parent_sign_up_response_body.g.dart';

@JsonSerializable()
class ParentSignUpResponseBody {
  final String message;

  const ParentSignUpResponseBody({
    required this.message,
  });

  factory ParentSignUpResponseBody.fromJson(Map<String, dynamic> json) =>
      _$ParentSignUpResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ParentSignUpResponseBodyToJson(this);
}
