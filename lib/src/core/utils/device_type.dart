// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum DeviceType {
  Mobile,
  Tablet,
  Desktop,
  Unknown,
}

class DeviceInfo {
  final double screenWidth;
  final double screenHeight;

  DeviceInfo({required this.screenWidth, required this.screenHeight});
}

class DeviceTypeChecker {
  static DeviceTypeChecker? _instance;

  factory DeviceTypeChecker() {
    _instance ??= DeviceTypeChecker._();
    return _instance!;
  }

  DeviceTypeChecker._();

  DeviceType getDeviceType(DeviceInfo deviceInfo) {
    final bool isMobile = deviceInfo.screenWidth < 600;
    final bool isTablet =
        deviceInfo.screenWidth >= 600 && deviceInfo.screenWidth < 1024;

    if (isMobile) {
      return DeviceType.Mobile;
    } else if (isTablet) {
      return DeviceType.Tablet;
    } else if (kIsWeb) {
      return DeviceType.Desktop;
    } else {
      return DeviceType.Unknown;
    }
  }

  DeviceInfo getDeviceInfo(BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final double screenWidth = mediaQuery.size.width;
    final double screenHeight = mediaQuery.size.height;

    return DeviceInfo(screenWidth: screenWidth, screenHeight: screenHeight);
  }
}

//To check device type use this

// DeviceTypeChecker deviceTypeChecker = DeviceTypeChecker();
// DeviceInfo deviceInfo = deviceTypeChecker.getDeviceInfo(context);
// DeviceType deviceType = deviceTypeChecker.getDeviceType(deviceInfo);

// // Example usage based on the device type
// if (deviceType == DeviceType.Mobile) {
//   // Mobile-specific logic
// } else if (deviceType == DeviceType.Tablet) {
//   // Tablet-specific logic
// } else if (deviceType == DeviceType.Desktop) {
//   // Desktop-specific logic
// } else {
//   // Unknown device type logic
// }
