import 'package:flutter_test/flutter_test.dart';
import 'package:h1/features/roster/data/repositories/character_repository_impl.dart';
import 'package:h1/features/roster/data/repositories/in_memory_character_repository.dart';
import 'package:h1/features/roster/data/services/character_asset_service.dart';
import 'package:h1/features/roster/data/services/element_asset_service.dart';
import 'package:h1/features/roster/data/services/role_asset_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sumber in-memory sama dengan seluruh data karakter JSON', () async {
    const jsonRepository = CharacterRepositoryImpl(
      characterService: CharacterAssetService(),
      elementService: ElementAssetService(),
      roleService: RoleAssetService(),
    );
    const inMemoryRepository = InMemoryCharacterRepository();

    expect(
      await inMemoryRepository.loadCharacters(),
      await jsonRepository.loadCharacters(),
    );
  });
}
