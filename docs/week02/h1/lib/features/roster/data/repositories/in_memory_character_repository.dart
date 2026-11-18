import '../../domain/models/character.dart';
import '../../domain/models/element.dart';
import '../../domain/models/role.dart';
import '../../domain/repositories/character_repository.dart';

/// Sumber data pengganti tanpa file: dipakai untuk bukti source-swap dan tes.
///
/// Isinya mencerminkan seluruh karakter JSON, termasuk elemen dan role
/// yang dipakai aplikasi. Tes membandingkan hasil loadCharacters dari kedua sumber.
class InMemoryCharacterRepository implements CharacterRepository {
  const InMemoryCharacterRepository();

  static const _fire = Element(id: 'fire', name: 'Fire');
  static const _water = Element(id: 'water', name: 'Water');
  static const _lightning = Element(id: 'lightning', name: 'Lightning');
  static const _dark = Element(id: 'dark', name: 'Dark');

  static const _dps = Role(id: 'dps', name: 'DPS');
  static const _support = Role(id: 'support', name: 'Support');
  static const _striker = Role(id: 'striker', name: 'Striker');
  static const _assassin = Role(id: 'assassin', name: 'Assassin');
  static const _mage = Role(id: 'mage', name: 'Grand Mage DPS');
  static const _supremeSupport = Role(
    id: 'supremeSupport',
    name: 'Supreme Support',
  );
  static const _vanguard = Role(id: 'vanguard', name: 'Striker Vanguard');
  static const _shadowAssassin = Role(
    id: 'shadowAssassin',
    name: 'Shadow Assassin',
  );

  static const _characters = <Character>[
    Character(
      id: 'kaelen',
      name: 'Kaelen',
      imageUrl: 'assets/charactercard/Kaelan.jpg',
      element: _fire,
      role: _dps,
    ),
    Character(
      id: 'aria',
      name: 'Aria',
      imageUrl: 'assets/charactercard/water.jpg',
      element: _water,
      role: _support,
    ),
    Character(
      id: 'sol',
      name: 'Sol',
      imageUrl: 'assets/charactercard/fireboy.jpg',
      element: _fire,
      role: _striker,
    ),
    Character(
      id: 'nyx',
      name: 'Nyx',
      imageUrl: 'assets/charactercard/Nyx.jpg',
      element: _dark,
      role: _assassin,
    ),
    Character(
      id: 'valerius',
      name: 'Archmage Valerius Ignis Highflame the Third Commander of the Elemental Citadel and Guardian of the Eternal Sacred Spark of Eldoria',
      imageUrl: 'assets/charactercard/fireboy.jpg',
      element: _fire,
      role: _mage,
    ),
    Character(
      id: 'aurelia',
      name: 'Princess Aurelia Hydroina Tidecaller Empress of the Seven Oceanic Realm Waters and Protector of Abyssal Sanctuary Depths',
      imageUrl: 'assets/charactercard/water.jpg',
      element: _water,
      role: _supremeSupport,
    ),
    Character(
      id: 'stormbringer',
      name: 'Lord Kaelen Stormbringer Thunderbolt Master of High Voltage Lightning and Harbinger of Tempestuous Cataclysms',
      imageUrl: 'assets/charactercard/Kaelan.jpg',
      element: _lightning,
      role: _vanguard,
    ),
    Character(
      id: 'nyx-shadowblade',
      name: 'Shadowblade Nyx Umbra Soulreaper Sovereign of Nightfall Realm and Whisperer of Void Darkness',
      imageUrl: 'assets/charactercard/Nyx.jpg',
      element: _dark,
      role: _shadowAssassin,
    ),
  ];

  @override
  Future<List<Character>> loadCharacters() async => _characters;
}
