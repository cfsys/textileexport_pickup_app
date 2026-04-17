import 'dart:async';

import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/DashBoard/LocationGatePage.dart';
import 'package:textile_exporter_admin/Library/ApiData.dart';

import '../Library/AppStorage.dart';

class LocationUpdateController extends GetxController with WidgetsBindingObserver implements GetxService {
  Timer? _timer;
  bool _started = false;
  bool _isRunning = false;
  bool _isRedirecting = false;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    _timer?.cancel();
    _timer = null;
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Foreground-only updates (background tracking needs platform work).
    if (state == AppLifecycleState.resumed) {
      _ensureTimer();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached ||
        state == AppLifecycleState.inactive) {
      _timer?.cancel();
      _timer = null;
    }
  }

  void start() {
    if (_started) return;
    _started = true;
    _ensureTimer();
    // First update on app open (Home reached).
    _updateOnce();
  }

  void _ensureTimer() {
    _timer ??= Timer.periodic(const Duration(minutes: 5), (_) => _updateOnce());
  }

  String _formatAddress(Placemark p) {
    final parts = <String?>[
      p.name,
      p.street,
      p.subLocality,
      p.locality,
      p.administrativeArea,
      p.postalCode,
      p.country,
    ].where((e) => (e ?? "").trim().isNotEmpty).map((e) => e!.trim()).toList();

    final seen = <String>{};
    final unique = <String>[];
    for (final part in parts) {
      if (seen.add(part)) unique.add(part);
    }
    return unique.join(", ");
  }

  Future<void> _blockLocationUpdatesAndGoToGate() async {
    if (_isRedirecting) return;
    _isRedirecting = true;

    _timer?.cancel();
    _timer = null;
    _started = false;

    // Navigate first; delete controller on the next frame to avoid disposing mid-callstack.
    Get.offAll(() => const LocationGatePage());
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<LocationUpdateController>()) {
        Get.delete<LocationUpdateController>(force: true);
      }
    });
  }

  Future<void> _updateOnce() async {
    if (_isRunning || _isRedirecting) return;
    _isRunning = true;
    try {
      late Position position;
      try {
        final serviceEnabled = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabled) {
          await _blockLocationUpdatesAndGoToGate();
          return;
        }

        final permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
          await _blockLocationUpdatesAndGoToGate();
          return;
        }

        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
          ),
        ).timeout(const Duration(minutes: 5));

        // Some devices can briefly return a last-known fix after GPS is toggled off.
        // Re-check service state before posting to server / deciding we're "healthy".
        final serviceEnabledAfterFix = await Geolocator.isLocationServiceEnabled();
        if (!serviceEnabledAfterFix) {
          await _blockLocationUpdatesAndGoToGate();
          return;
        }
      } catch (_) {
        // If we can't obtain a fix (common when user dismisses the system "improve location accuracy"
        // dialog with "No thanks", or GPS can't produce a timely position), send the user back
        // through the gate flow.
        await _blockLocationUpdatesAndGoToGate();
        return;
      }

      var addressText = "";
      List<dynamic> addressList = [];
      try {
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        if (placemarks.isNotEmpty) {
          addressText = _formatAddress(placemarks.first);
          addressList = placemarks;
        }
      } catch (_) {}

      try {
        await ApiData().postData('update_location', {
          'uid': await AppStorage.getData("uid") ?? "",
          'latitude': position.latitude.toString(),
          'longitude': position.longitude.toString(),
          'address_text': addressText,
          'address_data': addressList,
        });
      } catch (_) {}
    } finally {
      _isRunning = false;
    }
  }
}
