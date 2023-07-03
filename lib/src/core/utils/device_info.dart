import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInfoUtil {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static DeviceInfo? _deviceInfo;

  static Future<DeviceInfo> getDetails() async {
    var info = _deviceInfo;

    if (info != null) return info;
    if (Platform.isAndroid) {
      info = await _getAndroidinfo();
    } else if (Platform.isIOS) {
      info = await _getIosinfo();
    } else {
      info = DeviceInfo.Empty();
    }
    return info;
  }

  static Future<DeviceInfo> _getIosinfo() async {
    final device = await _deviceInfoPlugin.iosInfo;
    return DeviceInfo(
        uuid: device.identifierForVendor ?? "",
        manufacturer: 'APPLE',
        model: device.name ?? '',
        product: device.model ?? '',
        os: 'OS',
        osversion: device.systemVersion ?? '');
  }

  static Future<DeviceInfo> _getAndroidinfo() async {
    final device = await _deviceInfoPlugin.androidInfo;
    return DeviceInfo(
        uuid: device.id,
        manufacturer: device.manufacturer,
        model: device.device,
        product: device.product,
        os: 'OS',
        osversion: device.version.release);
  }
}

class DeviceInfo {
  final String uuid;
  final String manufacturer;
  final String model;
  final String product;
  final String os;
  final String osversion;

  DeviceInfo({
    required this.uuid,
    required this.manufacturer,
    required this.model,
    required this.product,
    required this.os,
    required this.osversion,
  });
  factory DeviceInfo.Empty() => DeviceInfo(
      uuid: '',
      manufacturer: '',
      model: "",
      product: '',
      os: '',
      osversion: "");
}
