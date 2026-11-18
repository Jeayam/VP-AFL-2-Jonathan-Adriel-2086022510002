import 'package:flutter_test/flutter_test.dart';
import 'package:h1/core/errors/storage_exception.dart';
import 'package:h1/features/settings/viewmodels/settings_state.dart';
import 'package:h1/features/settings/viewmodels/settings_view_model.dart';

import '../../helpers/fakes.dart';

void main() {
  late FakeSettingsRepository repository;
  late SettingsViewModel viewModel;

  setUp(() {
    repository = FakeSettingsRepository();
    viewModel = SettingsViewModel(repository);
    addTearDown(viewModel.dispose);
  });

  test('memuat nilai tema yang tersimpan', () async {
    repository.darkMode = false;

    await viewModel.load();

    expect(viewModel.state, const SettingsLoaded(isDarkMode: false));
    expect(viewModel.isDarkMode, isFalse);
  });

  test(
    'kegagalan memuat tema menampilkan pesan dan memakai tema gelap',
    () async {
      repository.loadError = const FormatException('default rusak');

      await viewModel.load();

      expect(
        viewModel.state,
        const SettingsFailure(
          'Pengaturan tema gagal dimuat. Tema gelap digunakan sementara.',
        ),
      );
      expect(viewModel.isDarkMode, isTrue);
    },
  );

  test('mengganti tema menyimpan nilai baru', () async {
    await viewModel.load();

    await viewModel.toggleTheme();

    expect(viewModel.isDarkMode, isFalse);
    expect(repository.saved, [false]);
  });

  test('kegagalan menyimpan mengembalikan tema sebelumnya', () async {
    await viewModel.load();
    repository.saveError = const StorageException('gagal tulis');

    await viewModel.toggleTheme();

    expect(
      viewModel.state,
      const SettingsFailure(
        'Perubahan tema gagal disimpan. Coba lagi.',
        isDarkMode: true,
      ),
    );
    expect(viewModel.isDarkMode, isTrue);
  });
}
