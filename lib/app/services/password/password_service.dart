import 'dart:convert';

import 'package:crypto/crypto.dart';

class PasswordService {
  static String hashed(String str) {
    var bytes = utf8.encode(str);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }
}
