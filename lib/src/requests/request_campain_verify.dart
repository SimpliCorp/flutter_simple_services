import '../models/models.dart';

class CampainVerifyRequest {
  final Map<String, dynamic>? data;
  final OptionsModel options;

  const CampainVerifyRequest({required this.data, required this.options});

  Map<String, dynamic> toJson() {
    if (data == null) {
      return {"options": options.toJson()};
    }
    // If data is not null, include it in the JSON representation
    return {"data": data, "options": options.toJson()};
  }
}
