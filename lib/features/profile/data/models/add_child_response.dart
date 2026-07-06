import 'package:json_annotation/json_annotation.dart';

part 'add_child_response.g.dart';

@JsonSerializable()
class AddChildResponse {
  final String message;
  final int childId;

  const AddChildResponse({
    required this.message,
    required this.childId,
  });

  factory AddChildResponse.fromJson(Map<String, dynamic> json) =>
      _$AddChildResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AddChildResponseToJson(this);
}
