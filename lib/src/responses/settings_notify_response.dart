import 'dart:convert';

SettingsNotifyResponse settingsNotifyResponseFromJson(String str) =>
    SettingsNotifyResponse.fromJson(json.decode(str));

String settingsNotifyResponseToJson(SettingsNotifyResponse data) =>
    json.encode(data.toJson());

class SettingsNotifyResponse {
  final bool enabled;

  SettingsNotifyResponse({required this.enabled});

  factory SettingsNotifyResponse.fromJson(Map<String, dynamic> json) =>
      SettingsNotifyResponse(enabled: json["enabled"]);

  Map<String, dynamic> toJson() => {"enabled": enabled};
}
