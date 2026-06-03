import 'package:json_annotation/json_annotation.dart';

part 'doctor_sign_up_response_body.g.dart';

@JsonSerializable()
class DoctorSignUpResponseBody {
  final String message;

  const DoctorSignUpResponseBody({required this.message});

  factory DoctorSignUpResponseBody.fromJson(Map<String, dynamic> json) =>
      _$DoctorSignUpResponseBodyFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorSignUpResponseBodyToJson(this);
}
