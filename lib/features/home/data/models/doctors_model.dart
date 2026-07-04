import 'package:json_annotation/json_annotation.dart';
import 'package:soliel/core/network/api_constants.dart';

part 'doctors_model.g.dart';

@JsonSerializable()
class DoctorModel {
  @JsonKey(defaultValue: 0)
  final int id;
  @JsonKey(defaultValue: '')
  final String fullName;
  @JsonKey(defaultValue: '')
  final String education;
  @JsonKey(defaultValue: 0)
  final int experienceYears;
  @JsonKey(defaultValue: '')
  final String city;
  @JsonKey(defaultValue: '')
  final String clinicPhone;
  @JsonKey(defaultValue: '')
  final String workingHours;
  @JsonKey(defaultValue: '')
  final String profileImage;
  @JsonKey(defaultValue: '')
  final String certificateImage;

  const DoctorModel({
    required this.id,
    required this.fullName,
    required this.education,
    required this.experienceYears,
    required this.city,
    required this.clinicPhone,
    required this.workingHours,
    required this.profileImage,
    required this.certificateImage,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) =>
      _$DoctorModelFromJson(json);

  Map<String, dynamic> toJson() => _$DoctorModelToJson(this);

  /// Absolute URL for the doctor's profile image.
  String get profileImageUrl => ApiConstants.doctorImageUrl(profileImage);

  /// Absolute URL for the doctor's certificate image.
  String get certificateImageUrl =>
      ApiConstants.doctorImageUrl(certificateImage);
}
