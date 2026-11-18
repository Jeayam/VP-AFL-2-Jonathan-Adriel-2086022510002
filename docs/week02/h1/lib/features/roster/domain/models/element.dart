import 'package:equatable/equatable.dart';

class Element extends Equatable {
  final String id;
  final String name;

  const Element({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
