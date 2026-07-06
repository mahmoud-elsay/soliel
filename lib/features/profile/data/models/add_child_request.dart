import 'package:json_annotation/json_annotation.dart';

part 'add_child_request.g.dart';

@JsonSerializable()
class AddChildRequest {
  final String name;
  final String birthDate;
  final String gender;

  const AddChildRequest({
    required this.name,
    required this.birthDate,
    required this.gender,
  });

  factory AddChildRequest.fromJson(Map<String, dynamic> json) =>
      _$AddChildRequestFromJson(json);

  Map<String, dynamic> toJson() => _$AddChildRequestToJson(this);
}
