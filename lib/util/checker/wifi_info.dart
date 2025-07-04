import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';

// Replace the print statements with this function
Future<void> getNetworkInfo() async {
  if (kIsWeb) {
    debugPrint('⚠️ Network info not available on web platform');
    return;
  }

  try {
    // Create a map to store all network info
    final networkInfo = NetworkInfo();
    final Map<String, String?> networkDetails = {};

    // Gather all network info asynchronously
    final futures = await Future.wait([
      networkInfo.getWifiName().then((value) => networkDetails['SSID'] = value),
      networkInfo.getWifiIP().then((value) => networkDetails['IP'] = value),
      networkInfo.getWifiIPv6().then((value) => networkDetails['IPv6'] = value),
      networkInfo.getWifiSubmask().then((value) => networkDetails['Submask'] = value),
      networkInfo.getWifiGatewayIP().then((value) => networkDetails['Gateway'] = value),
      networkInfo.getWifiBSSID().then((value) => networkDetails['BSSID'] = value),
    ]);

    // Log all collected info in a structured format
    debugPrint('📡 Network Information:');
    networkDetails.forEach((key, value) => debugPrint('  $key: ${value ?? 'Not available'}'));
  } catch (e) {
    debugPrint('❌ Error retrieving network info: $e');
  }
}
