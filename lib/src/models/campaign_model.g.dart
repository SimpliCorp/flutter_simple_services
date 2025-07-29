// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CampaignModel _$CampaignModelFromJson(Map<String, dynamic> json) =>
    CampaignModel(
      id: json['id'] as String?,
      mediaSource: json['media_source'] as String?,
      provider: json['provider'] as String?,
      redeemID: json['redeem_id'] as String?,
      namespace: json['namespace'] as String?,
      bundles:
          (json['bundles'] as List<dynamic>?)?.map((e) => e as String).toList(),
      status: json['status'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$CampaignModelToJson(CampaignModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'media_source': instance.mediaSource,
      'provider': instance.provider,
      'redeem_id': instance.redeemID,
      'namespace': instance.namespace,
      'bundles': instance.bundles,
      'status': instance.status,
      'name': instance.name,
      'description': instance.description,
      'created_at': instance.createdAt,
    };
