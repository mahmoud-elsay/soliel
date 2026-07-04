// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctors_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DoctorModel _$DoctorModelFromJson(Map<String, dynamic> json) => DoctorModel(
  id: (json['id'] as num?)?.toInt() ?? 0,
  fullName: json['fullName'] as String? ?? '',
  education: json['education'] as String? ?? '',
  experienceYears: (json['experienceYears'] as num?)?.toInt() ?? 0,
  city: json['city'] as String? ?? '',
  clinicPhone: json['clinicPhone'] as String? ?? '',
  workingHours: json['workingHours'] as String? ?? '',
  profileImage: json['profileImage'] as String? ?? '',
  certificateImage: json['certificateImage'] as String? ?? '',
);

Map<String, dynamic> _$DoctorModelToJson(DoctorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'education': instance.education,
      'experienceYears': instance.experienceYears,
      'city': instance.city,
      'clinicPhone': instance.clinicPhone,
      'workingHours': instance.workingHours,
      'profileImage': instance.profileImage,
      'certificateImage': instance.certificateImage,
    };
