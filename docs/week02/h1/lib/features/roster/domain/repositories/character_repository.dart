import '../models/character.dart';

abstract interface class CharacterRepository {
  Future<List<Character>> loadCharacters();
}
