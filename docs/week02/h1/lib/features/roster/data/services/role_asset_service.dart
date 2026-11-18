import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/role_model.dart';

class RoleAssetService {
  const RoleAssetService();

  Future<List<RoleModel>> loadRoles() async {
    const assetPath = 'assets/data/role.json';
    final source = await rootBundle.loadString(assetPath);
    final decoded = jsonDecode(source);
    if (decoded is! List) {
      throw const FormatException(
        'Data pada $assetPath harus berupa daftar JSON.',
      );
    }

    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException(
              'Setiap item pada $assetPath harus berupa objek JSON.',
            );
          }
          return RoleModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
