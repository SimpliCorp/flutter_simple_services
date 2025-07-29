import 'package:flutter_simple_services/src/services/simple_services_manager.dart';

class OptionsModel {
  OptionsModel({this.namespace, this.bundle});

  String? namespace;
  String? bundle;

  OptionsModel copyWith({String? namespace, String? bundle}) => OptionsModel(
    namespace: namespace ?? this.namespace,
    bundle: bundle ?? this.bundle,
  );

  factory OptionsModel.fromJson(Map<String, dynamic> json) =>
      OptionsModel(namespace: json["namespace"], bundle: json["bundle"]);

  static OptionsModel defaultOptions() {
    return OptionsModel(
      namespace: "l7mobile",
      bundle: SimpleServicesManager.instance.bundleId,
    );
  }

  Map<String, dynamic> toJson() => {"namespace": namespace, "bundle": bundle};
}
