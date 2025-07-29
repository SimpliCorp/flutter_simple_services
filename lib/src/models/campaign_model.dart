import 'package:json_annotation/json_annotation.dart';

part 'campaign_model.g.dart';

@JsonSerializable()
class CampaignModel {
  final String? id;
  @JsonKey(name: 'media_source')
  final String? mediaSource;
  final String? provider;
  @JsonKey(name: 'redeem_id')
  final String? redeemID;
  final String? namespace;
  final List<String>? bundles;
  final String? status;
  final String? name;
  final String? description;
  @JsonKey(name: 'created_at')
  final String? createdAt;

  const CampaignModel({
    this.id,
    this.mediaSource,
    this.provider,
    this.redeemID,
    this.namespace,
    this.bundles,
    this.status,
    this.name,
    this.description,
    this.createdAt,
  });

  factory CampaignModel.fromJson(Map<String, dynamic> json) =>
      _$CampaignModelFromJson(json);

  Map<String, dynamic> toJson() => _$CampaignModelToJson(this);
}
