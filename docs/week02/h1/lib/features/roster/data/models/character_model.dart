import '../../domain/models/character.dart';
import '../../domain/models/element.dart';
import '../../domain/models/role.dart';

class CharacterModel {
  final String id;
  final String name;
  final String imageUrl;
  final String elementId;
  final String roleId;

  const CharacterModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.elementId,
    required this.roleId,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      imageUrl: _requiredString(json, 'imageUrl'),
      elementId: _requiredString(json, 'elementId'),
      roleId: _requiredString(json, 'roleId'),
    );
  }

  Character toEntity({required Element element, required Role role}) {
    return Character(
      id: id,
      name: name,
      imageUrl: imageUrl,
      element: element,
      role: role,
    );
  }

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
