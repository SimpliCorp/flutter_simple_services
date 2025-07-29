import 'package:dio/dio.dart';
import 'package:flutter_simple_services/flutter_simple_services.dart';
import 'package:flutter_simple_services/src/services/api_config.dart';
import '../requests/requests.dart';
import '../responses/responses.dart';

class AppRepository {
  AppRepository._internal() {
    _dio = DioClient().dio; //DioOptions().createDio();
    _apiClient = ApiService(_dio, baseUrl: kBaseUrl);
  }

  static final AppRepository _singleton = AppRepository._internal();

  factory AppRepository() {
    return _singleton;
  }

  ///dio safe http client
  late Dio _dio;

  ///Api client
  late ApiService _apiClient;

  void setToken(String token) {
    AppRepository._internal();
  }

  //----> AUTH
  Future<UserTokenModel> authToken(AuthTokenRequest request) {
    return _apiClient.authToken(request);
  }

  Future<UserTokenModel> refreshToken(RefreshTokenRequest request) {
    return _apiClient.refeshAuthToken(request);
  }

  // --> NOTIFICATION

  Future<ResponseModel> registerDeviceToken(
    String transport,
    String address,
    String uid,
    Map<String, dynamic> options,
    String os,
  ) {
    return _apiClient.registerDeviceToken(transport, address, uid, options, os);
  }

  Future<TopicResponse> getListTopics(
    String userId,
    int offset,
    int limit,
    String namespace,
  ) {
    return _apiClient.getListTopics(userId, offset, limit, namespace);
  }

  Future<NotificationResponse> getListNotifications(
    String userId,
    int offset,
    int limit,
    String namespace,
  ) {
    return _apiClient.getListNotifications(userId, offset, limit, namespace);
  }

  Future<NotificationResponse> readNotifications(List<String> ids) {
    return _apiClient.readNotifications(ids);
  }

  Future<ResponseModel> deleteNotifications(List<String> ids) {
    return _apiClient.deleteNotifications(ids);
  }

  Future<ResponseModel> deleteNotificationsAll() {
    return _apiClient.deleteNotificationsAll(true);
  }

  Future<SettingsNotifyResponse> getSettingsNotify(
    String userId,
    String namespace,
  ) {
    return _apiClient.getSettingsNotify(userId, namespace);
  }

  Future<ResponseModel> setSettingsNotify(
    String userId,
    bool enabled,
    Map<String, dynamic> options,
  ) {
    return _apiClient.setSettingsNotify(userId, enabled, options);
  }

  Future<StatusesModel> getStatusesNotify(
    String userId,
    String namespace,
    String bundle,
  ) {
    return _apiClient.getStatusesNotify(userId, namespace, bundle);
  }

  // Campaigns
  Future<CampaignsResponse> getListCampaigns(
    String userId,
    int offset,
    int limit,
    String namespace,
    String bundle,
  ) {
    return _apiClient.getListCampaigns(offset, limit, namespace, bundle);
  }

  Future<ResponseModel> verifyCampaign(
    String campaignId,
    CampainVerifyRequest request,
  ) {
    return _apiClient.verifyCampaign(campaignId, request);
  }

  Future<DeeplinkModel> getInviteLinkCampaign(
    String campaignId,
    Map<String, dynamic> options,
  ) {
    return _apiClient.getInviteLinkCampaigns(campaignId, options);
  }

  Future<RedeemUseModel> useRedeemCode(
    String redeemCode,
    String userId,
    String refId,
    String mid,
    Map<String, dynamic> options,
  ) {
    return _apiClient.useRedeemCode(redeemCode, userId, refId, mid, options);
  }

  Future<ActivationFunctionModel> getActivationFunctions(
    String refId,
    String functions,
    String namespace,
    String bundle,
  ) {
    return _apiClient.getActivationFunctions(
      refId,
      functions,
      namespace,
      bundle,
    );
  }
}
