import 'package:json_annotation/json_annotation.dart';

class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is DateTime) return json;
    if (json is String) return DateTime.parse(json);
    if (json.runtimeType.toString() == 'Timestamp') {
      return (json as dynamic).toDate() as DateTime;
    }
    throw Exception('Cannot convert $json to DateTime');
  }

  @override
  dynamic toJson(DateTime object) => object.toIso8601String();
}
