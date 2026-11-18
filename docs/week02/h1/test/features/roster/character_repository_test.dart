import 'package:flutter_test/flutter_test.dart';
import 'package:h1/features/roster/data/repositories/character_repository_impl.dart';
import 'package:h1/features/roster/data/services/character_asset_service.dart';
import 'package:h1/features/roster/data/services/element_asset_service.dart';
import 'package:h1/features/roster/data/services/role_asset_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late CharacterRepositoryImpl repository;

  setUp(() {
    repository = const CharacterRepositoryImpl(
      characterService: CharacterAssetService(),
      elementService: ElementAssetService(),
      roleService: RoleAssetService(),
    );
  });

  test(
    'menggabungkan JSON karakter, elemen, dan role berdasarkan ID',
    () async {
      final characters = await repository.loadCharacters();

      expect(characters, hasLength(8));
      expect(characters.first.name, 'Kaelen');
      expect(characters.first.element.name, 'Fire');
      expect(characters.first.role.name, 'DPS');
    },
  );

  test('memuat data judul normal dan panjang dari katalog JSON', () async {
    final characters = await repository.loadCharacters();

    expect(
      characters.where((character) => character.name.length <= 40),
      hasLength(4),
    );
    expect(
      characters.where((character) => character.name.length > 40),
      hasLength(4),
    );
  });
}
