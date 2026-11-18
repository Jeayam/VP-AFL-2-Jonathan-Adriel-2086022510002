import 'dart:async';

import 'package:flutter/material.dart';

import '../viewmodels/character_detail_state.dart';
import '../viewmodels/character_detail_view_model.dart';
import 'widgets/character_detail_dialog.dart';

class CharacterDetailScreen extends StatefulWidget {
  final String characterId;
  final CharacterDetailViewModel Function(String characterId) createViewModel;
  final VoidCallback onBack;

  const CharacterDetailScreen({
    super.key,
    required this.characterId,
    required this.createViewModel,
    required this.onBack,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen> {
  late final CharacterDetailViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel(widget.characterId);
    unawaited(_viewModel.load());
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _viewModel,
          builder: (context, _) {
            final state = _viewModel.state;
            return switch (state) {
              CharacterDetailLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              CharacterDetailFailure(:final message) => _DetailError(
                message: message,
                onBack: widget.onBack,
                onRetry: _viewModel.load,
              ),
              CharacterDetailNotFound() => _CharacterNotFound(
                onBack: widget.onBack,
              ),
              CharacterDetailLoaded() => _buildCharacter(state),
            };
          },
        ),
      ),
    );
  }

  Widget _buildCharacter(CharacterDetailLoaded state) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (state.historyMessage != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  state.historyMessage!,
                  style: const TextStyle(color: Colors.orangeAccent),
                  textAlign: TextAlign.center,
                ),
              ),
            CharacterDetailDialog(
              character: state.character,
              stats: state.stats,
              onClose: widget.onBack,
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterNotFound extends StatelessWidget {
  final VoidCallback onBack;

  const _CharacterNotFound({required this.onBack});

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.person_search, size: 40),
          const SizedBox(height: 12),
          const Text('Karakter tidak ditemukan.'),
          const SizedBox(height: 12),
          FilledButton(onPressed: onBack, child: const Text('Kembali')),
        ],
      ),
    ),
  );
}

class _DetailError extends StatelessWidget {
  final String message;
  final VoidCallback onBack;
  final VoidCallback onRetry;

  const _DetailError({
    required this.message,
    required this.onBack,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
          TextButton(onPressed: onBack, child: const Text('Kembali')),
        ],
      ),
    ),
  );
}
