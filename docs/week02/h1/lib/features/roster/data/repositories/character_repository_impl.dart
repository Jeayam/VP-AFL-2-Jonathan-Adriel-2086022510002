import '../../domain/models/character.dart';
import '../../domain/models/element.dart';
import '../../domain/models/role.dart';
import '../../domain/repositories/character_repository.dart';
import '../services/character_asset_service.dart';
import '../services/element_asset_service.dart';
import '../services/role_asset_service.dart';

class CharacterRepositoryImpl implements CharacterRepository {
  final CharacterAssetService characterService;
  final ElementAssetService elementService;
  final RoleAssetService roleService;

  const CharacterRepositoryImpl({
    required this.characterService,
    required this.elementService,
    required this.roleService,
  });

  @override
  Future<List<Character>> loadCharacters() async {
    final characterModels = await characterService.loadCharacters();
    final elements = await elementService.loadElements();
    final roles = await roleService.loadRoles();

    final elementById = <String, Element>{};
    for (final model in elements) {
      final entity = model.toEntity();
      if (elementById.containsKey(entity.id)) {
        throw FormatException('ID elemen duplikat: ${entity.id}');
      }
      elementById[entity.id] = entity;
    }

    final roleById = <String, Role>{};
    for (final model in roles) {
      final entity = model.toEntity();
      if (roleById.containsKey(entity.id)) {
        throw FormatException('ID role duplikat: ${entity.id}');
      }
      roleById[entity.id] = entity;
    }

    final characterIds = <String>{};
    return characterModels
        .map((model) {
          if (!characterIds.add(model.id)) {
            throw FormatException('ID karakter duplikat: ${model.id}');
          }
          final element = elementById[model.elementId];
          final role = roleById[model.roleId];
          if (element == null) {
            throw FormatException(
              'Elemen "${model.elementId}" tidak ditemukan.',
            );
          }
          if (role == null) {
            throw FormatException('Role "${model.roleId}" tidak ditemukan.');
          }
          return model.toEntity(element: element, role: role);
        })
        .toList(growable: false);
  }
}
