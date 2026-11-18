import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/element_model.dart';

class ElementAssetService {
  const ElementAssetService();

  Future<List<ElementModel>> loadElements() async {
    const assetPath = 'assets/data/elemen.json';
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
          return ElementModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
