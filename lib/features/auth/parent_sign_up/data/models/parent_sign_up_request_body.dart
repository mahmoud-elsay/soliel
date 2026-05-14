import 'package:json_annotation/json_annotation.dart';

part 'parent_sign_up_request_body.g.dart';

@JsonSerializable()
class ParentSignUpRequestBody {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String relation;

  const ParentSignUpRequestBody({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.relation,
  });

  factory ParentSignUpRequestBody.fromJson(Map<String, dynamic> json) =>
      _$ParentSignUpRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$ParentSignUpRequestBodyToJson(this);
}
