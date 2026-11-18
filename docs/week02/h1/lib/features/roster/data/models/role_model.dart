import '../../domain/models/role.dart';

class RoleModel {
  final String id;
  final String name;

  const RoleModel({required this.id, required this.name});

  factory RoleModel.fromJson(Map<String, dynamic> json) {
    return RoleModel(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
    );
  }

  Role toEntity() => Role(id: id, name: name);

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
