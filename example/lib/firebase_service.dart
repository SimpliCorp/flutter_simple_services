import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_simple_services/flutter_simple_services.dart';
import 'firebase_options.dart';
import 'log.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static bool _isInitialized = false;
  static Future<void>? _initializationFuture;

  FirebaseService._internal();

  static FirebaseService get instance {
    _instance ??= FirebaseService._internal();
    return _instance!;
  }

  /// Khởi tạo Firebase và SimpleServicesManager
  /// Chỉ khởi tạo một lần duy nhất
  Future<void> initialize() async {
    if (_isInitialized) return;

    // Nếu đang trong quá trình khởi tạo, chờ nó hoàn thành
    if (_initializationFuture != null) {
      return _initializationFuture!;
    }

    _initializationFuture = _performInitialization();
    return _initializationFuture!;
  }

  Future<void> _performInitialization() async {
    try {
      logInfo("Starting Firebase initialization...");

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      logInfo("Firebase initialized successfully");

      await SimpleServicesManager.instance.initialize();

      logInfo("SimpleServicesManager initialized successfully");

      _isInitialized = true;
    } catch (e) {
      logError("Firebase initialization failed: $e");
      _initializationFuture = null; // Reset để có thể thử lại
      rethrow;
    }
  }

  /// Kiểm tra xem Firebase đã được khởi tạo chưa
  bool get isInitialized => _isInitialized;

  /// Đảm bảo Firebase được khởi tạo trước khi thực hiện action
  Future<void> ensureInitialized() async {
    if (!_isInitialized) {
      await initialize();
    }
  }
}
