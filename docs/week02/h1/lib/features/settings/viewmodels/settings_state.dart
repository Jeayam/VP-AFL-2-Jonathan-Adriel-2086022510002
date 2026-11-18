import 'package:equatable/equatable.dart';

sealed class SettingsState extends Equatable {
  const SettingsState();
}

final class SettingsLoading extends SettingsState {
  const SettingsLoading();

  @override
  List<Object?> get props => [];
}

final class SettingsLoaded extends SettingsState {
  final bool isDarkMode;

  const SettingsLoaded({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

final class SettingsFailure extends SettingsState {
  final String message;
  final bool isDarkMode;

  const SettingsFailure(this.message, {this.isDarkMode = true});

  @override
  List<Object?> get props => [message, isDarkMode];
}
