import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../flows/game_launcher.dart';
import '../l10n/l10n.dart';
import '../services/game_save_store.dart';
import '../services/settings_store.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';
import '../widgets/continue_card.dart';
import '../widgets/difficulty_sheet.dart';
import '../widgets/overwrite_dialog.dart';
import '../widgets/remove_ads_card.dart';
import '../widgets/weekly_card.dart';
import 'prepare_screen.dart';
import 'records_screen.dart';
import 'settings_screen.dart';
import 'weekly_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkSave());
  }

  /// 호환되지 않는 세이브는 삭제하고 안내를 1회 띄운다.
  void _checkSave() {
    if (!mounted) return;
    final saves = context.read<GameSaveStore?>();
    final settings = context.read<SettingsStore>();
    if (saves == null) return;
    if (saves.load() is LoadIncompatible &&
        !settings.saveIncompatibleNoticeShown) {
      settings.markSaveIncompatibleNoticeShown();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.saveIncompatible)));
    }
  }

  Future<void> _newGame() async {
    final saves = context.read<GameSaveStore?>();
    if (saves?.meta.value != null) {
      if (!await confirmOverwrite(context) || !mounted) return;
    }
    final d = await DifficultySheet.show(context);
    if (d == null || !mounted) return;
    // 세이브는 여기서 지우지 않는다. 새 GameScreen 이 시작될 때 덮어쓴다 (D18).
    Navigator.push(
      context,
      MaterialPageRoute<void>(builder: (_) => PrepareScreen(difficulty: d)),
    );
  }

  void _continue() {
    final saves = context.read<GameSaveStore?>();
    final r = saves?.load();
    if (r is LoadOk) {
      Navigator.push(context, gameRoute(GameSeed.saved(r.game)));
    } else if (r is LoadIncompatible) {
      _checkSave();
    }
  }

  @override
  Widget build(BuildContext context) {
    final saves = context.read<GameSaveStore?>();
    final weekly = context.read<AppDeps>().weekly;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppTheme.maxContentWidth,
            ),
            child: LayoutBuilder(
              builder: (context, box) => SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.pagePadding,
                  vertical: 24,
                ),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: box.maxHeight - 48),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        const AppLogo(showTagline: true),
                        const SizedBox(height: 48),
                        _PrimaryButton(onPressed: _newGame),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: _SecondaryButton(
                                icon: Icons.emoji_events_outlined,
                                label: context.l10n.records,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => const RecordsScreen(),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _SecondaryButton(
                                icon: Icons.settings_outlined,
                                label: context.l10n.settings,
                                onPressed: () => Navigator.push(
                                  context,
                                  MaterialPageRoute<void>(
                                    builder: (_) => const SettingsScreen(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (saves != null)
                          ValueListenableBuilder<SavedGameMeta?>(
                            valueListenable: saves.meta,
                            builder: (context, meta, _) => meta == null
                                ? const SizedBox.shrink()
                                : Padding(
                                    padding: const EdgeInsets.only(top: 24),
                                    child: ContinueCard(
                                      meta: meta,
                                      onTap: _continue,
                                    ),
                                  ),
                          ),
                        if (weekly != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: WeeklyCard(
                              service: weekly,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute<void>(
                                  builder: (_) => WeeklyScreen(service: weekly),
                                ),
                              ),
                            ),
                          ),
                        const Spacer(),
                        const SizedBox(height: 24),
                        const RemoveAdsCard(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  const _PrimaryButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => FilledButton.icon(
    style: FilledButton.styleFrom(
      minimumSize: const Size.fromHeight(56),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
      elevation: 2,
      shadowColor: AppTheme.primary.withValues(alpha: 0.4),
    ),
    onPressed: onPressed,
    icon: const Icon(Icons.play_arrow_rounded),
    label: Text(context.l10n.newGame),
  );
}

class _SecondaryButton extends StatelessWidget {
  const _SecondaryButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
    style: OutlinedButton.styleFrom(
      minimumSize: const Size.fromHeight(52),
      backgroundColor: AppTheme.surface,
    ),
    onPressed: onPressed,
    icon: Icon(icon, size: 20),
    label: Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
  );
}
