import 'package:h1/features/roster/domain/models/character.dart';
import 'package:h1/features/roster/domain/models/element.dart';
import 'package:h1/features/roster/domain/models/role.dart';

const _fire = Element(id: 'fire', name: 'Fire');
const _water = Element(id: 'water', name: 'Water');
const _dps = Role(id: 'dps', name: 'DPS');
const _support = Role(id: 'support', name: 'Support');
const _striker = Role(id: 'striker', name: 'Striker');
const _mage = Role(id: 'mage', name: 'Grand Mage DPS');

const kaelen = Character(
  id: 'kaelen',
  name: 'Kaelen',
  imageUrl: 'assets/charactercard/Kaelan.jpg',
  element: _fire,
  role: _dps,
);

const aria = Character(
  id: 'aria',
  name: 'Aria',
  imageUrl: 'assets/charactercard/water.jpg',
  element: _water,
  role: _support,
);

const sol = Character(
  id: 'sol',
  name: 'Sol',
  imageUrl: 'assets/charactercard/fireboy.jpg',
  element: _fire,
  role: _striker,
);

const valerius = Character(
  id: 'valerius',
  name: 'Archmage Valerius Ignis Highflame the Third',
  imageUrl: 'assets/charactercard/fireboy.jpg',
  element: _fire,
  role: _mage,
);

const testHistoryCharacter = Character(
  id: 'hero',
  name: 'Test Hero',
  imageUrl: '',
  element: _fire,
  role: _dps,
);

const testHistoryCharacters = <Character>[
  testHistoryCharacter,
  kaelen,
  aria,
  sol,
];

const testCharacters = <Character>[kaelen, aria, sol, valerius];
