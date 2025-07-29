import '../models/options_model.dart';

class AuthTokenRequest {
  final String token;
  final int tokenExpiry;
  final OptionsModel? options;

  const AuthTokenRequest({
    required this.token,
    required this.tokenExpiry,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    "token": token,
    "token_expiry": tokenExpiry,
    "options": options?.toJson(),
  };
}

class RefreshTokenRequest {
  final String refreshToken;
  final int tokenExpiry;
  final OptionsModel? options;

  const RefreshTokenRequest({
    required this.refreshToken,
    required this.tokenExpiry,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    "refresh_token": refreshToken,
    "token_expiry": tokenExpiry,
    "options": options?.toJson(),
  };
}

class OptionsRequest {
  final OptionsModel? options;

  const OptionsRequest({required this.options});

  Map<String, dynamic> toJson() => {"options": options?.toJson()};
}

class ScanVerifyRequest {
  final String code;
  final String accessToken;
  final OptionsModel? options;

  const ScanVerifyRequest({
    required this.code,
    required this.accessToken,
    required this.options,
  });

  Map<String, dynamic> toJson() => {
    "code": code,
    "token": {"access_token": accessToken},
    "options": options?.toJson(),
  };
}
