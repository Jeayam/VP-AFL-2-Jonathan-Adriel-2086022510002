import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/errors/storage_exception.dart';
import '../models/history_record_model.dart';

class HistoryFileService {
  static const _fileName = 'character_history.json';
  static const _legacyStorageKey = 'character_history';

  final File? file;

  const HistoryFileService({this.file});

  Future<List<HistoryRecordModel>> loadHistory() async {
    final file = await _historyFile();
    try {
      if (await file.exists()) {
        return _decode(await file.readAsString());
      }

      return await _migrateLegacyHistory(file);
    } on FileSystemException {
      throw const StorageException(
        'History tidak berhasil dibaca dari file lokal.',
      );
    }
  }

  List<HistoryRecordModel> _decode(String encoded) {
    final decoded = jsonDecode(encoded);
    if (decoded is! List) {
      throw const FormatException('Data history tersimpan tidak valid.');
    }
    return decoded
        .map((item) {
          if (item is! Map<String, dynamic>) {
            throw const FormatException('Item history tersimpan tidak valid.');
          }
          return HistoryRecordModel.fromJson(item);
        })
        .toList(growable: false);
  }

  Future<void> saveHistory(List<HistoryRecordModel> records) async {
    final file = await _historyFile();
    await _writeHistory(file, records);
  }

  Future<void> _writeHistory(
    File file,
    List<HistoryRecordModel> records,
  ) async {
    final encoded = jsonEncode(
      records.map((record) => record.toJson()).toList(),
    );
    try {
      await file.parent.create(recursive: true);
      await file.writeAsString(encoded, encoding: utf8, flush: true);
    } on FileSystemException {
      throw const StorageException(
        'History tidak berhasil disimpan ke file lokal.',
      );
    }
  }

  Future<void> clearHistory() async {
    final file = await _historyFile();
    try {
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      throw const StorageException(
        'History tidak berhasil dihapus dari file lokal.',
      );
    }

    final preferences = await SharedPreferences.getInstance();
    final removed = await preferences.remove(_legacyStorageKey);
    if (!removed && preferences.containsKey(_legacyStorageKey)) {
      throw const StorageException(
        'History lama tidak berhasil dihapus dari penyimpanan lokal.',
      );
    }
  }

  Future<File> _historyFile() async {
    final injectedFile = file;
    if (injectedFile != null) return injectedFile;

    final directory = await getApplicationSupportDirectory();
    return File('${directory.path}${Platform.pathSeparator}$_fileName');
  }

  Future<List<HistoryRecordModel>> _migrateLegacyHistory(File file) async {
    final preferences = await SharedPreferences.getInstance();
    final encoded = preferences.getString(_legacyStorageKey);
    if (encoded == null) return const [];

    final records = _decode(encoded);
    await _writeHistory(file, records);
    await preferences.remove(_legacyStorageKey);
    return records;
  }
}
