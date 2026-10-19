enum TestDatasetMode { standard, longList, longText, empty }

class CharacterModel {
  static final List<Map<String, String>> standardCharacters = [
    {'name': 'Kaelen', 'element': 'Fire', 'role': 'DPS', 'imageUrl': 'assets/charactercard/Kaelan.jpg'},
    {'name': 'Aria', 'element': 'Water', 'role': 'Support', 'imageUrl': 'assets/charactercard/water.jpg'},
    {'name': 'Sol', 'element': 'Fire', 'role': 'Striker', 'imageUrl': 'assets/charactercard/fireboy.jpg'},
    {'name': 'Nyx', 'element': 'Dark', 'role': 'Assassin', 'imageUrl': 'assets/charactercard/Nyx.jpg'},
  ];

  static final List<Map<String, String>> characters500 = List.generate(500, (index) {
    final elementsList = ['Fire', 'Water', 'Lightning', 'Dark'];
    final rolesList = ['DPS', 'Support', 'Striker', 'Assassin', 'Mage', 'Tank'];
    final imagesList = [
      'assets/charactercard/Kaelan.jpg',
      'assets/charactercard/water.jpg',
      'assets/charactercard/fireboy.jpg',
      'assets/charactercard/Nyx.jpg',
    ];
    final elem = elementsList[index % elementsList.length];
    final role = rolesList[index % rolesList.length];
    final img = imagesList[index % imagesList.length];
    return {
      'name': 'Hero #${index + 1} - Vanguard Specialist of the Order',
      'element': elem,
      'role': role,
      'imageUrl': img,
    };
  });

  static final List<Map<String, String>> longTextCharacters = [
    {
      'name': 'Archmage Valerius Ignis Highflame the Third Commander of the Elemental Citadel and Guardian of the Eternal Sacred Spark of Eldoria',
      'element': 'Fire',
      'role': 'Grand Mage DPS',
      'imageUrl': 'assets/charactercard/fireboy.jpg'
    },
    {
      'name': 'Princess Aurelia Hydroina Tidecaller Empress of the Seven Oceanic Realm Waters and Protector of Abyssal Sanctuary Depths',
      'element': 'Water',
      'role': 'Supreme Support',
      'imageUrl': 'assets/charactercard/water.jpg'
    },
    {
      'name': 'Lord Kaelen Stormbringer Thunderbolt Master of High Voltage Lightning and Harbinger of Tempestuous Cataclysms',
      'element': 'Lightning',
      'role': 'Striker Vanguard',
      'imageUrl': 'assets/charactercard/Kaelan.jpg'
    },
    {
      'name': 'Shadowblade Nyx Umbra Soulreaper Sovereign of Nightfall Realm and Whisperer of Void Darkness',
      'element': 'Dark',
      'role': 'Shadow Assassin',
      'imageUrl': 'assets/charactercard/Nyx.jpg'
    },
  ];
}
