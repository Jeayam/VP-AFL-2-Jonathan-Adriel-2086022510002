# Arsitektur Aplikasi Hero Codex

Alur aplikasi utama adalah:

```text
View -> ViewModel -> Repository -> Service -> JSON/SharedPreferences
```

View hanya menampilkan state. ViewModel mengatur alur interaksi dan UI state. Repository mengatur akses data. Service membaca atau menyimpan data. Model menyimpan representasi data yang digunakan aplikasi.

## Struktur Folder dan Tugas File

```text
lib/
  main.dart                              # Titik mulai aplikasi dan composition root
  app/
    app_router.dart                      # Routing, route argument, dan helper navigasi
    app_view_models_scope.dart           # Penyedia ViewModel bersama untuk seluruh route

  core/
    errors/
      storage_exception.dart             # Jenis error khusus untuk kegagalan penyimpanan
    theme/
      app_theme.dart                     # Tema terang dan gelap aplikasi

  features/
    roster/
      domain/
        models/
          character.dart                 # Entitas Character
          element.dart                   # Entitas Element
          role.dart                      # Entitas Role
        repositories/
          character_repository.dart      # Kontrak untuk mengambil data karakter

      data/
        models/
          character_model.dart           # DTO dan parsing JSON karakter
          element_model.dart             # DTO dan parsing JSON elemen
          role_model.dart                # DTO dan parsing JSON role
        services/
          character_asset_service.dart   # Membaca namecharacter.json
          element_asset_service.dart     # Membaca elemen.json
          role_asset_service.dart        # Membaca role.json
        repositories/
          character_repository_impl.dart # Menggabungkan JSON karakter, elemen, dan role
          in_memory_character_repository.dart # Sumber data pengganti untuk pengujian/swap

      viewmodels/
        roster_state.dart                # State Loading, Failure, Empty, dan Loaded roster
        roster_view_model.dart           # Load, search, filter, preset, dan filter state roster
        character_detail_state.dart      # State Loading, Failure, Not Found, dan Loaded detail
        character_detail_view_model.dart # Load detail karakter dan menambah history

      view/
        roster_screen.dart               # Layar utama roster dan container device preview
        character_detail_screen.dart     # Layar detail karakter
        widgets/
          character_card.dart            # Tampilan satu kartu karakter
          character_detail_dialog.dart   # Isi lengkap halaman detail
          roster_drawer.dart             # Menu navigasi
          roster_header.dart             # Search dan filter elemen
          emptystate.dart                # Tampilan ketika karakter tidak ditemukan

    history/
      domain/
        models/
          history_record.dart            # ID karakter dan waktu dilihat
          history_entry.dart             # Character lengkap beserta waktu dilihat
        repositories/
          history_repository.dart        # Kontrak membaca, menambah, dan menghapus history

      data/
        models/
          history_record_model.dart      # DTO JSON history
        services/
          history_file_service.dart      # Baca, tulis, hapus, dan migrasi file JSON history
          history_service.dart           # Aturan urutan dan penghapusan duplikat history
        repositories/
          history_repository_impl.dart   # Menghubungkan file, aturan history, dan karakter

      viewmodels/
        history_state.dart               # State Loading, Failure, Empty, dan Loaded history
        history_view_model.dart          # Mengelola load, ringkasan, dan clear history

      view/
        history_screen.dart              # Layar utama history
        widgets/
          history_header.dart            # Judul dan tombol hapus history
          history_item_tile.dart         # Tampilan satu item history
          history_stats_card.dart        # Ringkasan jumlah dan elemen terbanyak

    settings/
      domain/
        repositories/
          settings_repository.dart       # Kontrak load dan save pengaturan tema
      data/
        services/
          settings_service.dart          # Membaca default JSON dan menyimpan tema
        repositories/
          settings_repository_impl.dart  # Implementasi repository pengaturan
      viewmodels/
        settings_state.dart              # State Loading, Loaded, dan Failure tema
        settings_view_model.dart         # Mengubah dan menyimpan tema
      view/
        settings_screen.dart             # Layar pengaturan
        widgets/
          settings_header_tile.dart      # Judul bagian pengaturan
          settings_theme_card.dart       # Pengaturan tema terang/gelap
          settings_storage_card.dart     # Konfirmasi dan tombol hapus history

assets/
  data/
    namecharacter.json                   # Daftar karakter
    elemen.json                          # Daftar elemen
    role.json                            # Daftar role
    settings_defaults.json               # Nilai tema default


## Arah dan Pembagian Tanggung Jawab

| Bagian | Tugas |
|---|---|
| `view/` | Membuat UI, menampilkan state, dan meneruskan aksi pengguna |
| `viewmodels/` | Menyimpan UI state, memanggil repository, dan menyiapkan data untuk tampilan |
| `domain/` | Menyimpan model/domain dan kontrak repository |
| `data/repositories/` | Mengimplementasikan kontrak repository dan menggabungkan sumber data |
| `data/services/` | Membaca JSON/asset, menyimpan file, atau menerapkan aturan data |
| `data/models/` | Mengubah data JSON menjadi objek dan sebaliknya |
| `app/` | Mengatur navigasi dan penyediaan ViewModel |
| `main.dart` | Membuat repository, ViewModel, dan menghubungkan seluruh dependensi |