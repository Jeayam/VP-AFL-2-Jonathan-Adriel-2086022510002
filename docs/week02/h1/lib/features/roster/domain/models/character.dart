import 'package:equatable/equatable.dart';

import 'element.dart';
import 'role.dart';

class Character extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final Element element;
  final Role role;

  const Character({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.element,
    required this.role,
  });

  Character copyWith({String? id, String? name}) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl,
      element: element,
      role: role,
    );
  }

  @override
  List<Object?> get props => [id, name, imageUrl, element, role];
}
