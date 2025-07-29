import 'dart:async';
import 'dart:ffi';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:example/log.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_badge/flutter_native_badge.dart';
import 'package:flutter_simple_services/flutter_simple_services.dart';
import 'package:share_plus/share_plus.dart';

import 'admob/admob.dart';

// Alternative approach using StreamSubscription
class MyHomePageWithStream extends StatefulWidget {
  const MyHomePageWithStream({super.key, required this.title});

  final String title;

  @override
  State<MyHomePageWithStream> createState() => _MyHomePageWithStreamState();
}

class _MyHomePageWithStreamState extends State<MyHomePageWithStream> {
  List<CampaignModel> listCampaigns = [];
  StreamSubscription<InitializationStatus>? _statusSubscription;

  TextEditingController controller = TextEditingController();

  String freeStatus = "";
  bool isFreeAds = false;

  @override
  void initState() {
    super.initState();

    // Lắng nghe status stream
    _statusSubscription = SimpleServicesManager.instance.statusStream.listen(
      (status) {
        if (mounted) {
          switch (status) {
            case InitializationStatus.completed:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('✅ User is ready!'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 2),
                ),
              );
              // Tự động load campaigns khi ready
              getListCampaigns();
              break;
            case InitializationStatus.failed:
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('❌ Initialization failed'),
                  backgroundColor: Colors.red,
                ),
              );
              break;
            default:
              // Log các trạng thái khác
              print('Status: ${status.name}');
          }
        }
      },
      onError: (error) {
        print('Status stream error: $error');
      },
    );

    // WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
    //   final status =
    //       await AppTrackingTransparency.requestTrackingAuthorization();
    // });

    AppTrackingTransparency.requestTrackingAuthorization();
  }

  @override
  void dispose() {
    // Cancel stream subscription
    _statusSubscription?.cancel();
    controller.dispose();
    super.dispose();
  }

  Future<void> getListCampaigns() async {
    if (!SimpleServicesManager.instance.isUserReady) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please wait for initialization to complete'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    try {
      CampaignsResponse response = await SimpleServicesManager.instance
          .getListCampaigns(0, 10);

      if (mounted) {
        setState(() {
          listCampaigns = response.campaigns;
          listCampaigns.add(
            CampaignModel(
              id: "redeemcode",
              mediaSource: "REDEEM_CODE",
              name: "Redeem Code",
              description: "Ad-Free in 1 year.",
            ),
          );
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getActivationFunctions,
            tooltip: 'Refresh Campaigns',
          ),
        ],
      ),
      body: StreamBuilder<InitializationStatus>(
        stream: SimpleServicesManager.instance.statusStream,
        initialData: SimpleServicesManager.instance.currentStatus,
        builder: (context, snapshot) {
          final status = snapshot.data ?? InitializationStatus.notStarted;

          return Column(
            children: [
              // Status indicator using StreamBuilder
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      status == InitializationStatus.completed
                          ? Colors.green.withOpacity(0.1)
                          : status == InitializationStatus.failed
                          ? Colors.red.withOpacity(0.1)
                          : Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color:
                        status == InitializationStatus.completed
                            ? Colors.green
                            : status == InitializationStatus.failed
                            ? Colors.red
                            : Colors.orange,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      status == InitializationStatus.completed
                          ? Icons.check_circle
                          : status == InitializationStatus.failed
                          ? Icons.error
                          : Icons.hourglass_empty,
                      color:
                          status == InitializationStatus.completed
                              ? Colors.green
                              : status == InitializationStatus.failed
                              ? Colors.red
                              : Colors.orange,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Status: ${status.name}',
                      style: TextStyle(
                        color:
                            status == InitializationStatus.completed
                                ? Colors.green[700]
                                : status == InitializationStatus.failed
                                ? Colors.red[700]
                                : Colors.orange[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(18.0),
                child: Text(
                  'How to remove Ads:',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: listCampaigns.length,
                  itemBuilder: (context, index) {
                    final campaign = listCampaigns[index];
                    return _campaignItem(campaign);
                  },
                ),
              ),
              if (freeStatus.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      freeStatus,
                      style: TextStyle(
                        fontSize: 16,
                        color: isFreeAds ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getListCampaigns,
        tooltip: 'Campaigns',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _campaignItem(CampaignModel campaign) {
    return ListTile(
      title: Text(campaign.name ?? "No Name"),
      subtitle: Text(campaign.description ?? "No Description"),
      leading:
          campaign.mediaSource == "WATCH_ADS"
              ? const Icon(
                Icons.video_camera_front_outlined,
                size: 34,
                color: Colors.blueGrey,
              )
              : campaign.mediaSource == "REDEEM_CODE"
              ? const Icon(Icons.code)
              : const Icon(Icons.campaign),
      onTap: () {
        // Handle campaign tap
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Tapped on ${campaign.name}')));

        switch (campaign.mediaSource) {
          case "WATCH_ADS":
            // Logic for watching ads
            _viewRewardAds(campaign);
            break;
          case "INVITE":
            // Logic for inviting friends
            _getInviteLink(campaign);
            break;
          case "REDEEM_CODE":
            // Logic for redeeming code
            _redeemCode(campaign);
            break;
          default:
            // Handle other cases if needed
            break;
        }
      },
    );
  }

  //
  // Private method =======
  //
  _getActivationFunctions() async {
    try {
      final response =
          await SimpleServicesManager.instance.getActivationFunctions();
      print(response.expiredAt);
      print(response.timestamp);

      DateTime expiredAt = DateTime.parse(response.expiredAt ?? "");
      DateTime timestamp = DateTime.parse(response.timestamp ?? "");
      if (expiredAt.isBefore(timestamp)) {
        logError("Activation function expired at: $expiredAt");
        setState(() {
          isFreeAds = false;
          freeStatus = "Activation function expired at: $expiredAt";
        });
        return;
      } else {
        setState(() {
          isFreeAds = true;
          freeStatus = "Free status until: ${response.expiredAt}";
        });
      }
    } catch (e) {
      logError('Failed to get free status: $e');
    }

    try {
      var response = await SimpleServicesManager.instance.getStatusesNotify();
      var unreadCount = int.parse((response.unread ?? "0"));
      unreadCount > 0
          ? logSuccess('You have $unreadCount unread notifications')
          : logInfo('No unread notifications');

      bool isSupported = await FlutterNativeBadge.isSupported();
      if (isSupported) {
        FlutterNativeBadge.setBadgeCount(unreadCount);
      } else {
        logInfo('FlutterNativeBadge is not supported on this device');
      }
    } catch (error) {
      logError(error.toString());
    }
  }

  Future<void> _viewRewardAds(CampaignModel campaign) async {
    // ios test ca-app-pub-3940256099942544/1712485313
    var adsReward = AdmobReward(rewardId: AdmobConfig().rewardId());
    var earned = false;
    // Success case
    try {
      await adsReward.loadRewardedAdAsync();
      print('Ad loaded successfully!');
      adsReward.onRewardEarned = () {
        earned = true;
        logSuccess('Reward earned!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reward earned!'),
            backgroundColor: Colors.green,
          ),
        );
      };
      adsReward.onAdDismissed = () async {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ad dismissed'),
            backgroundColor: Colors.blue,
          ),
        );

        logSuccess('Ad dismissed Call api verify reward');

        try {
          await SimpleServicesManager.instance.verifyCampaign(
            campaign.id ?? "",
            null,
          );
          logSuccess('Reward verified successfully');
        } catch (e) {
          logError('Error verifying reward: $e');
        }
      };
      adsReward.showRewardedAd();
    } catch (e) {
      logError('Failed to load ad: $e');
    }

    // // Or with .then()
    // adsReward
    //     .loadRewardedAdAsync()
    //     .then((_) => print('Ad loaded!'))
    //     .catchError((error) => print('Error: $error'));
  }

  Future<void> _getInviteLink(CampaignModel campaign) async {
    var deeplink = await SimpleServicesManager.instance.getInviteLinkCampaign(
      campaign.id ?? "",
    );
    if (deeplink.url.isNotEmpty) {
      SharePlus.instance.share(ShareParams(uri: Uri.parse(deeplink.url)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to get invite link'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _redeemCode(CampaignModel campaign) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Redeem Code'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: 'Enter your redeem code',
            ),
            onSubmitted: (code) {
              // Call redeem code function
              Navigator.of(context).pop();
              logSuccess("Submitted code: $code");
              _verifyRedeemCode(campaign, code);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),

            TextButton(
              onPressed: () {
                // Call redeem code function
                _verifyRedeemCode(campaign, controller.text);

                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _verifyRedeemCode(CampaignModel campaign, String code) {
    print("Redeem code: $code for campaign: ${campaign.name}");
    SimpleServicesManager.instance
        .useRedeemCode(code)
        .then((redeemUseModel) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Redeem code used successfully: ${redeemUseModel.message}',
              ),
              backgroundColor: Colors.green,
            ),
          );
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error using redeem code: $error'),
              backgroundColor: Colors.red,
            ),
          );
        });
  }
}
