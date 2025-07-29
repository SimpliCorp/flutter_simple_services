import 'package:flutter/material.dart';
import 'package:flutter_simple_services/flutter_simple_services.dart';

class InitializationStatusWidget extends StatefulWidget {
  final Widget child;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const InitializationStatusWidget({
    super.key,
    required this.child,
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<InitializationStatusWidget> createState() =>
      _InitializationStatusWidgetState();
}

class _InitializationStatusWidgetState
    extends State<InitializationStatusWidget> {
  @override
  void initState() {
    super.initState();
  }

  String _getStatusMessage(InitializationStatus status) {
    switch (status) {
      case InitializationStatus.notStarted:
        return 'Preparing...';
      case InitializationStatus.initializingPackageInfo:
        return 'Getting app information...';
      case InitializationStatus.initializingFirebaseAuth:
        return 'Initializing Firebase Auth...';
      case InitializationStatus.authenticatingUser:
        return 'Authenticating user...';
      case InitializationStatus.gettingAccessToken:
        return 'Getting access token...';
      case InitializationStatus.completed:
        return 'Ready!';
      case InitializationStatus.failed:
        return 'Initialization failed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<InitializationStatus>(
      valueListenable: SimpleServicesManager.instance.initializationStatus,
      builder: (context, status, child) {
        if (status == InitializationStatus.completed) {
          return widget.child;
        }

        if (status == InitializationStatus.failed) {
          return widget.errorWidget ?? _buildErrorWidget();
        }

        return widget.loadingWidget ?? _buildLoadingWidget(status);
      },
    );
  }

  Widget _buildLoadingWidget(InitializationStatus status) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text(
              _getStatusMessage(status),
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Please wait...',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 20),
            const Text(
              'Initialization Failed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Unable to initialize the app services.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retry initialization
                SimpleServicesManager.instance.initialize();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
