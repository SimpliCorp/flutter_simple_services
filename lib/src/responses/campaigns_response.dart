import '../models/models.dart';

class CampaignsResponse {
  final List<CampaignModel> campaigns;

  CampaignsResponse({required this.campaigns});

  factory CampaignsResponse.fromJson(Map<String, dynamic> json) {
    return CampaignsResponse(
      campaigns:
          (json['campaigns'] as List<dynamic>)
              .map(
                (item) => CampaignModel.fromJson(item as Map<String, dynamic>),
              )
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'campaigns': campaigns.map((item) => item.toJson()).toList()};
  }
}
