import 'dart:convert';

class QRService {
  static String generateQRCode(String data) {
    // Simple QR code generation simulation
    return data;
  }

  static Map<String, dynamic> parseQRData(String qrData) {
    try {
      final params = qrData.split('&');
      final result = <String, dynamic>{};
      
      for (final param in params) {
        final parts = param.split('=');
        if (parts.length == 2) {
          result[parts[0]] = parts[1];
        }
      }
      
      return result;
    } catch (e) {
      return {};
    }
  }

  static String createDeviceQRData({
    required String name,
    required String ip,
    required String mac,
  }) {
    return 'name=$name&ip=$ip&mac=$mac';
  }
} 