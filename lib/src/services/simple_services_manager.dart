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

enum InitializationStatus {
  notStarted,
  initializingPackageInfo,
  initializingFirebaseAuth,
  authenticatingUser,
  gettingAccessToken,
  completed,
  failed,
}

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
  var transport = "firebase";
  var accessToken = "";

  // Biến để theo dõi trạng thái khởi tạo
  final ValueNotifier<InitializationStatus> _initializationStatus =
      ValueNotifier(InitializationStatus.notStarted);

  // Stream để lắng nghe thay đổi trạng thái
  final StreamController<InitializationStatus> _statusController =
      StreamController<InitializationStatus>.broadcast();

  // Getter để lắng nghe trạng thái khởi tạo
  ValueNotifier<InitializationStatus> get initializationStatus =>
      _initializationStatus;

  // Stream để lắng nghe thay đổi trạng thái
  Stream<InitializationStatus> get statusStream => _statusController.stream;

  // Getter để lấy trạng thái hiện tại
  InitializationStatus get currentStatus => _initializationStatus.value;

  // Check if user is ready
  bool get isUserReady =>
      _initializationStatus.value == InitializationStatus.completed;

  void _updateStatus(InitializationStatus status) {
    _initializationStatus.value = status;
    _statusController.add(status);
    logInfo("SimpleServicesManager status: ${status.name}");
  }

  Future<void> initialize() async {
    try {
      _updateStatus(InitializationStatus.initializingPackageInfo);

      // Initialization logic for SimpleServicesManager
      // This could include setting up services, configurations, etc.
      final packageInfo = await PackageInfo.fromPlatform();
      bundle = packageInfo.packageName;
      logInfo("Bundle ID: $bundle");

      _updateStatus(InitializationStatus.initializingFirebaseAuth);

      // Initialize Firebase Auth
      _updateStatus(InitializationStatus.authenticatingUser);
      UserCredential user = await FirebaseAuth.instance.signInAnonymously();

      if (user.user == null) {
        logError("Failed to sign in anonymously.");
        _updateStatus(InitializationStatus.failed);
        return;
      }

      logSuccess("Firebase Auth initialized successfully.");
      logInfo(
        "User ID: ${user.user?.uid ?? "Anonymous User id not available"}",
      );

      String firebaseUserId = user.user?.uid ?? '';
      String token = await user.user?.getIdToken() ?? '';

      _updateStatus(InitializationStatus.gettingAccessToken);

      // Get access token
      var request = AuthTokenRequest(
        token: token,
        tokenExpiry: kTokenExpiry,
        options: OptionsModel.defaultOptions(),
      );

      try {
        final tokenResponse = await AppRepository().authToken(request);
        userId = firebaseUserId;
        accessToken = tokenResponse.token?.accessToken ?? '';
        logSuccess("Simple Tech Access Token: $accessToken");

        _updateStatus(InitializationStatus.completed);
      } catch (error) {
        logError("Failed to get access token: $error");
        _updateStatus(InitializationStatus.failed);
      }
    } catch (error) {
      logError("Initialization failed: $error");
      _updateStatus(InitializationStatus.failed);
    }
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
  void dispose() {
    _statusController.close();
    _initializationStatus.dispose();
  }

  //
}
