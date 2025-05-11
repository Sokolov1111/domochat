import 'dart:convert';
import 'package:convert/convert.dart';

class CommunityCodec {

  static String encode (String uuid) {
    final cleanUUID = uuid.replaceAll('-', '');
    final bytes = hex.decode(cleanUUID);
    return base64Url.encode(bytes)
        .replaceAll('=', '')
        .replaceAll('/', '_')
        .replaceAll('+', '-')
        .substring(0,8)
        .toUpperCase();
  }

  static String decode(String code) {
    try {
      final normalizedCode = code
          .replaceAll('_', '/')
          .replaceAll('-', '+')
          .padRight(8, '=');
      final decoded = base64Url.decode(normalizedCode);
      final hexString = hex.encode(decoded).padLeft(32, '0');
      return '${hexString.substring(0, 8)}-'
          '${hexString.substring(8, 12)}-'
          '${hexString.substring(12, 16)}-'
          '${hexString.substring(16, 20)}-'
          '${hexString.substring(20)}';
    } catch (e) {
      throw const FormatException('Invalid community code');
    }
  }
}