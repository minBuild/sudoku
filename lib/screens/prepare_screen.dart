import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../app_deps.dart';
import '../flows/game_launcher.dart';
import '../l10n/strings.dart';
import '../models/difficulty.dart';
import '../services/purchase/purchase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/app_logo.dart';

/// 광고 게이트. 생성 ∥ 광고가 끝나면 GameScreen 으로 교체한다.
class PrepareScreen extends StatefulWidget {
  const PrepareScreen({super.key, required this.difficulty});

  final Difficulty difficulty;

  @override
  State<PrepareScreen> createState() => _PrepareScreenState();
}

class _PrepareScreenState extends State<PrepareScreen> {
  late final AppDeps _deps = context.read<AppDeps>();

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    final d = widget.difficulty;
    final launcher = GameLauncher(
      generate: _deps.generate,
      ads: _deps.ads,
      adsRemoved: _deps.entitlement.adsRemoved,
    );
    try {
      final r = await launcher.prepare(d);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        gameRoute(
          GameSeed.fresh(r.puzzle, d, _deps.settings.instantCheckDefault),
        ),
      );
    } catch (e) {
      // ParallelWaitError 포함. 광고가 떠 있었다면 이미 닫힌 뒤다 (D6).
      debugPrint('PrepareScreen: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(S.puzzleFailed)));
      Navigator.pop(context);
    }
  }

  void _buy() {
    _deps.ads.cancelPending(); // 표시 중이면 효과 없음 (D4)
    _deps.purchase.buy();
  }

  @override
  void dispose() {
    _deps.ads.cancelPending();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return PopScope(
      canPop: true,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppTheme.maxContentWidth,
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppTheme.pagePadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: 40),
                    const SizedBox(
                      width: 36,
                      height: 36,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        strokeCap: StrokeCap.round,
                        backgroundColor: AppTheme.primaryTint,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      S.preparing,
                      textAlign: TextAlign.center,
                      style: text.headlineSmall,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      S.preparingSub,
                      textAlign: TextAlign.center,
                      style: text.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 48),
                    _RemoveAdsButton(onPressed: _buy),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 미구매자이고 Ready 일 때만 보인다.
class _RemoveAdsButton extends StatelessWidget {
  const _RemoveAdsButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final deps = context.read<AppDeps>();
    return ValueListenableBuilder<bool>(
      valueListenable: deps.entitlement.adsRemoved,
      builder: (context, removed, _) => removed
          ? const SizedBox.shrink()
          : ValueListenableBuilder<PurchaseUiState>(
              valueListenable: deps.purchase.state,
              builder: (context, state, _) => state is PurchaseReady
                  ? FilledButton.tonalIcon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppTheme.primaryTint,
                        foregroundColor: AppTheme.primary,
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      onPressed: onPressed,
                      icon: const Icon(Icons.auto_awesome_outlined, size: 18),
                      label: Text(S.removeAdsWithPrice(state.price)),
                    )
                  : const SizedBox.shrink(),
            ),
    );
  }
}
