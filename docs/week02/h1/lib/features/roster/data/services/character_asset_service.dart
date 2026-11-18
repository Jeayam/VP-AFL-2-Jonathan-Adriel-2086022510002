import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/character_model.dart';

class CharacterAssetService {
  const CharacterAssetService();

  Future<List<CharacterModel>> loadCharacters() async {
    const assetPath = 'assets/data/namecharacter.json';
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
          return CharacterModel.fromJson(item);
        })
        .toList(growable: false);
  }
}
