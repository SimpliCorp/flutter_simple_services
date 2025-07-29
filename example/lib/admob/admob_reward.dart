import 'dart:async';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdmobReward {
  String rewardId;
  AdmobReward({required this.rewardId});

  RewardedAd? _rewardedAd;
  bool _isLoaded = false;

  // Callback functions
  Function? onRewardEarned;
  Function? onAdDismissed;

  void loadRewardedAd() {
    RewardedAd.load(
      adUnitId: rewardId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isLoaded = true;
          _setFullScreenContentCallback();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoaded = false;
          _rewardedAd = null;
        },
      ),
    );
  }

  Future<void> loadRewardedAdAsync() async {
    final completer = Completer<void>();

    RewardedAd.load(
      adUnitId: rewardId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (RewardedAd ad) {
          _rewardedAd = ad;
          _isLoaded = true;
          _setFullScreenContentCallback();
          completer.complete();
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isLoaded = false;
          _rewardedAd = null;
          completer.completeError(
            Exception('Failed to load rewarded ad: ${error.message}'),
          );
        },
      ),
    );

    return completer.future;
  }

  void _setFullScreenContentCallback() {
    _rewardedAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _isLoaded = false;
        _rewardedAd = null;
        onAdDismissed?.call();
        loadRewardedAd(); // Load next ad
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        ad.dispose();
        _isLoaded = false;
        _rewardedAd = null;
        loadRewardedAd(); // Load next ad
      },
    );
  }

  void showRewardedAd() {
    if (_isLoaded && _rewardedAd != null) {
      _rewardedAd!.show(
        onUserEarnedReward: (AdWithoutView ad, RewardItem rewardItem) {
          onRewardEarned?.call(rewardItem.amount, rewardItem.type);
        },
      );
    }
  }

  bool get isLoaded => _isLoaded;

  void dispose() {
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoaded = false;
  }
}
