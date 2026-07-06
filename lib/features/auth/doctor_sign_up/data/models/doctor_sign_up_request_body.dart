import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

part 'doctor_sign_up_request_body.g.dart';

@JsonSerializable(createFactory: false)
class DoctorSignUpRequestBody {
  @JsonKey(name: 'FirstName')
  final String firstName;
  @JsonKey(name: 'LastName')
  final String lastName;
  @JsonKey(name: 'Email')
  final String email;
  @JsonKey(name: 'Password')
  final String password;
  @JsonKey(name: 'ClinicPhone')
  final String clinicPhone;
  @JsonKey(name: 'NationalId')
  final String nationalId;
  @JsonKey(name: 'ExperienceYears')
  final int experienceYears;
  @JsonKey(name: 'City')
  final String city;
  @JsonKey(name: 'Street')
  final String street;
  @JsonKey(name: 'Building')
  final String building;
  @JsonKey(name: 'Education')
  final String education;
  @JsonKey(name: 'WorkingHours')
  final String workingHours;
  @JsonKey(includeToJson: false)
  final File certificateImage;
  @JsonKey(includeToJson: false)
  final File profileImage;

  const DoctorSignUpRequestBody({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    required this.clinicPhone,
    required this.nationalId,
    required this.experienceYears,
    required this.city,
    required this.street,
    required this.building,
    required this.education,
    required this.workingHours,
    required this.certificateImage,
    required this.profileImage,
  });

  Map<String, dynamic> toJson() => _$DoctorSignUpRequestBodyToJson(this);
}
