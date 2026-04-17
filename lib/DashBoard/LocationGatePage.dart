import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:textile_exporter_admin/DashBoard/HomePage.dart';
import 'package:textile_exporter_admin/Library/AppColors.dart';
import 'package:textile_exporter_admin/Library/AppTextStyle.dart';
import 'package:textile_exporter_admin/Library/Utils.dart';

enum _GateState {
  checking,
  permissionDenied,
  permissionDeniedForever,
  serviceDisabled,
  updating,
  error,
}

class LocationGatePage extends StatefulWidget {
  const LocationGatePage({super.key});

  @override
  State<LocationGatePage> createState() => _LocationGatePageState();
}

class _LocationGatePageState extends State<LocationGatePage> {
  _GateState state = _GateState.checking;
  String? errorText;

  @override
  void initState() {
    super.initState();
    _checkAndContinue();
  }

  Future<void> _checkAndContinue() async {
    setState(() {
      state = _GateState.checking;
      errorText = null;
    });

    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() => state = _GateState.serviceDisabled);
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() => state = _GateState.permissionDenied);
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() => state = _GateState.permissionDeniedForever);
        return;
      }

      setState(() => state = _GateState.updating);

      Get.offAll(() => const HomePage());
    } catch (e) {
      setState(() {
        state = _GateState.error;
        errorText = e.toString();
      });
    }
  }

  Widget _body() {
    switch (state) {
      case _GateState.checking:
      case _GateState.updating:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.primaryColor),
            const SizedBox(height: 16),
            Text(
              state == _GateState.updating ? "Updating location..." : "Checking location permission...",
              style: AppTextStyle.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );

      case _GateState.permissionDenied:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Please enable location permission to continue.", style: AppTextStyle.labelMedium, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            Utils().primaryButton(
              context: context,
              btnText: "Try again",
              onPress: _checkAndContinue,
            ),
          ],
        );

      case _GateState.permissionDeniedForever:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Location permission is permanently denied.\nPlease enable it from Settings.",
              style: AppTextStyle.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Utils().primaryButton(
              context: context,
              btnText: "Open settings",
              onPress: () async {
                await Geolocator.openAppSettings();
                await _checkAndContinue();
              },
            ),
            const SizedBox(height: 10),
            Utils().primaryButton(
              context: context,
              btnText: "Try again",
              btnColor: AppColors.grey_09,
              onPress: _checkAndContinue,
            ),
          ],
        );

      case _GateState.serviceDisabled:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Please turn ON Location (GPS) to continue.",
              style: AppTextStyle.labelMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Utils().primaryButton(
              context: context,
              btnText: "Open location settings",
              onPress: () async {
                await Geolocator.openLocationSettings();
                await _checkAndContinue();
              },
            ),
            const SizedBox(height: 10),
            Utils().primaryButton(
              context: context,
              btnText: "Try again",
              btnColor: AppColors.grey_09,
              onPress: _checkAndContinue,
            ),
          ],
        );

      case _GateState.error:
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Something went wrong while fetching location.",
              style: AppTextStyle.labelMedium,
              textAlign: TextAlign.center,
            ),
            if ((errorText ?? "").trim().isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                errorText.toString(),
                style: AppTextStyle.displayVeryVerySmall.copyWith(color: AppColors.red_55),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 16),
            Utils().primaryButton(
              context: context,
              btnText: "Try again",
              onPress: _checkAndContinue,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white_00,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: _body(),
          ),
        ),
      ),
    );
  }
}

