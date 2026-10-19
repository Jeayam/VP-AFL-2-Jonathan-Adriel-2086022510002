import 'package:flutter/foundation.dart';

class HistoryService {
  static final ValueNotifier<List<Map<String, String>>> historyNotifier =
      ValueNotifier<List<Map<String, String>>>([]);

  static void addCharacter(Map<String, String> char) {
    final current = List<Map<String, String>>.from(historyNotifier.value);
    current.removeWhere((item) => item['name'] == char['name']);
    final charWithTime = Map<String, String>.from(char);
    charWithTime['viewedAt'] = 'Just now';
    current.insert(0, charWithTime);
    historyNotifier.value = current;
  }

  static void clearHistory() {
    historyNotifier.value = [];
  }
}
