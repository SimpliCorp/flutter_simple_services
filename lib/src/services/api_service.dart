import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../models/models.dart';
import '../requests/requests.dart';
import '../responses/responses.dart';
import 'api_config.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: kBaseUrl)
abstract class ApiService {
  factory ApiService(Dio dio, {String? baseUrl}) = _ApiService;

  /// Login
  @POST("sidecar/firebase/auth/token")
  Future<UserTokenModel> authToken(@Body() AuthTokenRequest request);

  @POST("auth/token")
  Future<UserTokenModel> refeshAuthToken(@Body() RefreshTokenRequest request);

  // Notification functions
  // Register device token
  @POST("/notify/{transport}/register")
  Future<ResponseModel> registerDeviceToken(
    @Path('transport') String transport,
    @Field('address') String address,
    @Field('uid') String uid,
    @Field('options') Map<String, dynamic> options,
    @Field('os') String os,
  );

  // Get list topics
  @GET("/notify/topics")
  Future<TopicResponse> getListTopics(
    @Query('user_id') String userId,
    @Query('offset') int offset,
    @Query('limit') int limit,
    @Query('options.namespace') String namespace,
  );

  // Get list notifications
  @GET("/users/{user_id}/notifies")
  Future<NotificationResponse> getListNotifications(
    @Path('user_id') String userId,
    @Query('offset') int offset,
    @Query('limit') int limit,
    @Query('options.namespace') String namespace,
  );

  // Read notifications
  @POST("/notifies/read")
  Future<NotificationResponse> readNotifications(
    @Field('ids') List<String> ids,
  );

  // Delete notifications
  @POST("/notifies/delete")
  Future<ResponseModel> deleteNotifications(@Field('ids') List<String> ids);

  @POST("/notifies/delete")
  Future<ResponseModel> deleteNotificationsAll(@Field('all') bool all);

  // Get settings enable notification
  @GET("/users/{user_id}/settings/notify")
  Future<SettingsNotifyResponse> getSettingsNotify(
    @Path('user_id') String userId,
    @Query('options.namespace') String namespace,
  );

  @PUT("/users/{user_id}/settings/notify")
  Future<ResponseModel> setSettingsNotify(
    @Path('user_id') String userId,
    @Field('enabled') bool enabled,
    @Field('options') Map<String, dynamic> options,
  );

  @GET("/users/{user_id}/statuses/notify")
  Future<StatusesModel> getStatusesNotify(
    @Path('user_id') String userId,
    @Query('options.namespace') String namespace,
    @Query('options.bundle') String bundle,
  );

  // Campaign functions
  @GET("/campaigns")
  Future<CampaignsResponse> getListCampaigns(
    @Query('offset') int offset,
    @Query('limit') int limit,
    @Query('options.namespace') String namespace,
    @Query('options.bundle') String bundle,
  );

  @POST("campaigns/{campaignId}/verify")
  Future<ResponseModel> verifyCampaign(
    @Path('campaignId') String campaignId,
    @Body() CampainVerifyRequest request,
  );

  @POST("campaigns/{campaignId}/deep-link")
  Future<DeeplinkModel> getInviteLinkCampaigns(
    @Path('campaignId') String campaignId,
    @Field('options') Map<String, dynamic> options,
  );

  @POST("payment/redeems/{redeemCode}/use")
  Future<RedeemUseModel> useRedeemCode(
    @Path('redeemCode') String redeemCode,
    @Field('uid') String userId,
    @Field('ref_id') String refId,
    @Field('mid') String mid,
    @Field('options') Map<String, dynamic> options,
  );

  @GET("payment/activation-functions")
  Future<ActivationFunctionModel> getActivationFunctions(
    @Query('ref_id') String refId,
    @Query('functions') String functions,
    @Query('options.namespace') String namespace,
    @Query('options.bundle') String bundle,
  );
}
