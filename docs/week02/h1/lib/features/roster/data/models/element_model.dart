import '../../domain/models/element.dart';

class ElementModel {
  final String id;
  final String name;

  const ElementModel({required this.id, required this.name});

  factory ElementModel.fromJson(Map<String, dynamic> json) {
    return ElementModel(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
    );
  }

  Element toEntity() => Element(id: id, name: name);

  static String _requiredString(Map<String, dynamic> json, String key) {
    final value = json[key];
    if (value is! String || value.isEmpty) {
      throw FormatException(
        'Field "$key" harus berupa teks dan tidak boleh kosong.',
      );
    }
    return value;
  }
}
