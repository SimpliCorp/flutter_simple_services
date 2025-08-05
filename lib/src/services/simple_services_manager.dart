import 'dart:io';

import 'package:flutter_simple_services/src/log.dart';
import 'package:flutter_simple_services/src/models/models.dart';
import 'package:flutter_simple_services/src/repository/api_repository.dart';
import 'package:flutter_simple_services/src/requests/request_auth_token.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'dart:async';

import '../requests/requests.dart';
import '../responses/responses.dart';
import 'api_config.dart';

class SimpleServicesManager {
  static SimpleServicesManager? _instance;

  SimpleServicesManager._internal();

  static SimpleServicesManager get instance {
    _instance ??= SimpleServicesManager._internal();
    return _instance!;
  }

  var bundle = "";
  var namespace = "l7mobile";
  var userId = "";
  var transport = "FIREBASE";
  var accessToken = "";

  Future<void> initialize({String namespace = "l7mobile"}) async {
    try {
      this.namespace = namespace;

      // Initialization logic for SimpleServicesManager
      // This could include setting up services, configurations, etc.
      final packageInfo = await PackageInfo.fromPlatform();
      bundle = packageInfo.packageName;
      logInfo("Bundle ID: $bundle");
    } catch (e) {
      logError("Failed to initialize SimpleServicesManager: $e");
    }
  }

  setLoginedUserId(String userId, String accessToken) {
    this.userId = userId;
    this.accessToken = accessToken;
    logSuccess("User ID set to: $userId");
    logSuccess("Access Token set to: $accessToken");
  }

  Future<UserTokenModel> authToken(String token) {
    AuthTokenRequest request = AuthTokenRequest(
      token: token,
      tokenExpiry: kTokenExpiry,
      options: OptionsModel.defaultOptions(),
    );
    return AppRepository().authToken(request);
  }

  Future<UserTokenModel> refreshToken(String token) {
    RefreshTokenRequest request = RefreshTokenRequest(
      refreshToken: token,
      tokenExpiry: kTokenExpiry,
      options: OptionsModel.defaultOptions(),
    );
    return AppRepository().refreshToken(request);
  }

  Future<ResponseModel> registerDeviceToken(String address) {
    return AppRepository().registerDeviceToken(
      transport,
      address,
      userId,
      OptionsModel.defaultOptions().toJson(),
      Platform.isIOS ? "IOS" : "ANDROID",
    );
  }

  Future<TopicResponse> getListTopics() {
    return AppRepository().getListTopics(userId, 0, 99, namespace);
  }

  Future<NotificationResponse> getListNotifications(int offset, int limit) {
    return AppRepository().getListNotifications(
      userId,
      offset,
      limit,
      namespace,
    );
  }

  Future<NotificationResponse> readNotifications(List<String> ids) {
    return AppRepository().readNotifications(ids);
  }

  Future<ResponseModel> deleteNotifications(List<String> ids) {
    return AppRepository().deleteNotifications(ids);
  }

  Future<ResponseModel> deleteNotificationsAll() {
    return AppRepository().deleteNotificationsAll();
  }

  Future<SettingsNotifyResponse> getSettingsNotify() {
    return AppRepository().getSettingsNotify(userId, namespace);
  }

  Future<ResponseModel> setSettingsNotify(bool enabled) {
    return AppRepository().setSettingsNotify(
      userId,
      enabled,
      OptionsModel.defaultOptions().toJson(),
    );
  }

  Future<StatusesModel> getStatusesNotify() {
    return AppRepository().getStatusesNotify(userId, namespace, bundle);
  }

  // Campaign functions
  Future<CampaignsResponse> getListCampaigns(int offset, int limit) {
    return AppRepository().getListCampaigns(
      userId,
      offset,
      limit,
      namespace,
      bundle,
    );
  }

  Future<ResponseModel> verifyCampaign(
    String campaignId,
    Map<String, dynamic>? data,
  ) {
    CampainVerifyRequest request = CampainVerifyRequest(
      data: data,
      options: OptionsModel.defaultOptions(),
    );
    return AppRepository().verifyCampaign(campaignId, request);
  }

  Future<DeeplinkModel> getInviteLinkCampaign(String campaignId) {
    return AppRepository().getInviteLinkCampaign(
      campaignId,
      OptionsModel.defaultOptions().toJson(),
    );
  }

  Future<RedeemUseModel> useRedeemCode(String redeemCode) {
    return AppRepository().useRedeemCode(
      redeemCode,
      userId,
      userId,
      'redeem',
      OptionsModel.defaultOptions().toJson(),
    );
  }

  Future<ActivationFunctionModel> getActivationFunctions() {
    return AppRepository().getActivationFunctions(
      userId,
      "1", //Fixed function by default
      namespace,
      bundle,
    );
  }

  // Dispose resources
  void dispose() {}

  //
}
